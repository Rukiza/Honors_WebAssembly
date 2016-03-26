(module
    (export "main" $main)
    (func $main 
        (local $i i32)
        (set_local $i (i32.const 0))
        (return) 
    )
)

(invoke "main")

