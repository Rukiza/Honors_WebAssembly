(module
    (export "main" $main)
    (func $main 
        (local $1 i32)
        (local $0 i32)
        (local $2 i32)
        (local $3 i32) 
        (local $4 i32)
        (block $body
            (set_local $1 (i32.const 0))
            (set_local $0 (get_local $1))
            (loop $loop
                (set_local $2 (i32.const 10))
                (if (i32.ge_s (get_local $0) (get_local $2))
                    (then) 
                    (else 
                        (set_local $3 (i32.const 1))
                        (set_local $4 (i32.add (get_local $0) (get_local $3)))
                        (set_local $0 (get_local $4))
                        (br $loop)
                    )
                )
             )
        )
    )
)
