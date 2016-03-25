(module 
    (export "list_add" $list_add)
    (export "list_size" $list_size)
    (export "list_get" $list_get)
    (export "list_set" $list_set)

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
    (memory 2048))

;; Tests running the array.

;; Array is empty
(assert_return (invoke "list_size" (i32.const 0)) (i32.const 0))

;; Array has one item
(invoke "list_add" (i32.const 0) (i32.const 10))
(assert_return (invoke "list_size" (i32.const 0)) (i32.const 1))

;; Array has two items ... and so on.
(invoke "list_add" (i32.const 0) (i32.const 12))
(assert_return (invoke "list_size" (i32.const 0)) (i32.const 2))

(invoke "list_add" (i32.const 0) (i32.const 14))
(assert_return (invoke "list_size" (i32.const 0)) (i32.const 3))

(invoke "list_add" (i32.const 0) (i32.const 16))
(assert_return (invoke "list_size" (i32.const 0)) (i32.const 4))

(invoke "list_add" (i32.const 0) (i32.const 18))
(assert_return (invoke "list_size" (i32.const 0)) (i32.const 5))

(invoke "list_add" (i32.const 0) (i32.const 20))
(assert_return (invoke "list_size" (i32.const 0)) (i32.const 6))

(assert_return (invoke "list_get" (i32.const 0) (i32.const 0)) (i32.const 10))
(assert_return (invoke "list_get" (i32.const 0) (i32.const 1)) (i32.const 12))
(assert_return (invoke "list_get" (i32.const 0) (i32.const 2)) (i32.const 14))
(assert_return (invoke "list_get" (i32.const 0) (i32.const 3)) (i32.const 16))
(assert_return (invoke "list_get" (i32.const 0) (i32.const 4)) (i32.const 18))
(assert_return (invoke "list_get" (i32.const 0) (i32.const 5)) (i32.const 20))

;; Set test;
(assert_return (invoke "list_set" (i32.const 0) (i32.const 5) (i32.const -2)) (i32.const 20))
(assert_return (invoke "list_get" (i32.const 0) (i32.const 5)) (i32.const -2))
