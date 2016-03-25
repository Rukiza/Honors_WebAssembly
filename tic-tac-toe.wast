(module 
    (export "list_add" $list_add)
    (export "list_size" $list_size)
    (export "list_get" $list_get)
    (export "list_set" $list_set)
    (export "init_ttt" $init_ttt)
    (export "play_turn" $play_turn)

    ;; Adds to the list at the end and returns the addres for loading that virable
    ;; currently used the variable

    (func $list_add (param $addr i32) (param $a1 i32) (result i32)
        (if (f32.eq (f32.load offset=4 (get_local $addr)) (f32.div (f32.const 1) (f32.const 0)))
            (then 
                (i32.store offset=4 (get_local $addr) (i32.add (get_local $addr) (i32.const 8)))
                (call $list_add (i32.load offset=4 (get_local $addr)) (get_local $a1)))
            (else
                (if (i32.eq (i32.load offset=4 (get_local $addr)) (i32.const 0))
                    (then 
                        (i32.store (get_local $addr) (get_local $a1))
                        (f32.store offset=4 (get_local $addr) (f32.div (f32.const 1) (f32.const 0)))
                        (get_local $addr))
                    (else
                        (call $list_add (i32.load offset=4 (get_local $addr)) (get_local $a1)))))))
    
    ;;Checks the size of the list recursivly.

    (func $list_size (param $addr i32) (result i32)
        (if (f32.eq (f32.load offset=4 (get_local $addr)) (f32.div (f32.const 1) (f32.const 0)))
            (then 
                (i32.const 1))
            (else
                (if (i32.eq (i32.load offset=4 (get_local $addr)) (i32.const 0))
                    (then 
                        (i32.const 0))
                    (else
                        (i32.add (call $list_size (i32.load offset=4 (get_local $addr))) (i32.const 1)))))))

    ;; Gets the value at the location.

    (func $list_get (param $addr i32) (param $loc i32) (result i32)
        (local $size i32)
        (set_local $size (call $list_size (get_local $addr)))
        (if (i32.lt_s (i32.sub (get_local $size) (get_local $loc)) (i32.const 0))
            (then
                (unreachable))
            (else 
                (if (i32.eq (get_local $loc) (i32.const 0))
                    (then
                        (i32.load (get_local $addr)))
                    (else 
                        (call $list_get (i32.load offset=4 (get_local $addr)) (i32.sub (get_local $loc) (i32.const 1))))))))

    ;; Sets the value at the location where the location is a index in the array.

    (func $list_set (param $addr i32) (param $loc i32) (param $a i32) (result i32)
        (local $size i32)
        (local $val i32)
        (set_local $size (call $list_size (get_local $addr)))
        (if (i32.lt_s (i32.sub (get_local $size) (get_local $loc)) (i32.const 0))
            (then
                (unreachable))
            (else 
                (if (i32.eq (get_local $loc) (i32.const 0))
                    (then
                        (set_local $val (i32.load (get_local $addr)))
                        (i32.store (get_local $addr) (get_local $a))
                        (get_local $val))
                    (else 
                        (call $list_set (i32.load offset=4 (get_local $addr)) (i32.sub (get_local $loc) (i32.const 1)) (get_local $a) ))))))
    
    ;; Init the tic tac toe game.
    
    (func $init_ttt (param $list i32) (result i32)
        (local $fast_init i32)
        (local $i i32)
        (set_local $i (i32.const 0))
        (set_local $fast_init (get_local $list))
        (loop $loop
            (block
                (if (i32.lt_s (get_local $i) (i32.const 9))
                    (then 
                        (set_local $fast_init (call $list_add (get_local $fast_init) (i32.const 0)))
                        (set_local $i (i32.add (get_local $i) (i32.const 1)))
                        (br $loop)
                    )
                )
            )
        )
        (get_local $list)
    )

    ;; Play a turn 
    ;; rows and colunms start at 1 and go to 3 inclusive.
    (func $play_turn (param $list i32) (param $val i32) (param $row i32) (param $col i32) (result i32)
        (local $r i32)
        (local $c i32)
        (set_local $r (i32.sub (get_local $row) (i32.const 1)))
        (set_local $c (i32.sub (get_local $col) (i32.const 1)))
        (call $list_set 
            (get_local $list) 
            (i32.add 
                (get_local $c) 
                (i32.mul (get_local $r) (i32.const 3))
            ) 
            (get_local $val)
        )
        (get_local $list)
    )

    (memory 2048))


(invoke "init_ttt" (i32.const 0))

;; Checks a single turn works.
(invoke "play_turn" (i32.const 0) (i32.const 1) (i32.const 2) (i32.const 2))
(assert_return (invoke "list_get" (i32.const 0) (i32.const 4)) (i32.const 1))

;; Player two plays a turn.
(invoke "play_turn" (i32.const 0) (i32.const 2) (i32.const 3) (i32.const 3))
(assert_return (invoke "list_get" (i32.const 0) (i32.const 8)) (i32.const 2))
