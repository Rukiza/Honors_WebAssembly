(module 
    (export "list_add" $list_add)
    (export "list_get" $list_get)

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

    ;;Get is currently is very simple. 
    ;;moving to new file to have it load the values 

    (func $list_get (param $addr i32) (result i32)
        (i32.load (get_local $addr)))
    (memory 2048))

;; Tests running the array.
(invoke "list_add" (i32.const 0) (i32.const 10))
(invoke "list_add" (i32.const 0) (i32.const 12))
(invoke "list_add" (i32.const 0) (i32.const 14))
(invoke "list_add" (i32.const 0) (i32.const 16))
(invoke "list_add" (i32.const 0) (i32.const 18))
(invoke "list_add" (i32.const 0) (i32.const 20))
(assert_return (invoke "list_get" (i32.const 0)) (i32.const 10))
(assert_return (invoke "list_get" (i32.const 8)) (i32.const 12))
(assert_return (invoke "list_get" (i32.const 16)) (i32.const 14))
(assert_return (invoke "list_get" (i32.const 24)) (i32.const 16))
(assert_return (invoke "list_get" (i32.const 32)) (i32.const 18))
(assert_return (invoke "list_get" (i32.const 40)) (i32.const 20))
