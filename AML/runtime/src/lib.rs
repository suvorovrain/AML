use std::io::{self, Write};
use std::process::abort;

#[repr(C)]
pub struct Closure {
    pub code: *const (),
    pub arity: i64,     
    pub applied: i64,   
    pub args: Vec<i64>, 
}

/// helper function to call a function with custom calling convention
#[inline(always)]
fn call_with_i64_args(code: *const (), args: &[i64]) -> i64 {
    unsafe {
        let f: extern "C" fn(i64, *const i64) -> i64 = std::mem::transmute(code);
        f(args.len() as i64, args.as_ptr())
    }
}

#[no_mangle]
pub extern "C" fn print_int(argc: i64, argv: *const i64) -> i64 {
    if argc != 1 {
        eprintln!("fatal: print_int expects 1 arg, got {}", argc);
        abort();
    }
    unsafe {
        let n = *argv.add(0);
        print!("{}", n);
        io::stdout().flush().unwrap();
        n
    }
}

#[no_mangle]
pub extern "C" fn closure_alloc(func: *const (), arity: i64) -> i64 {
    if arity < 0 || arity > 1_000_000 {
        eprintln!("fatal: closure_alloc: insane arity {}", arity);
        abort();
    }
    let clos = Closure {
        code: func,
        arity,
        applied: 0,
        args: Vec::with_capacity(arity as usize),
    };
    Box::into_raw(Box::new(clos)) as i64
}

/// applies new arguments to a closure. leaks original closure and allocates new closure on partial application
/// caller must ensure `clos_raw` and `argv` are valid pointers
#[no_mangle]
pub unsafe extern "C" fn closure_apply(clos_raw: i64, argc: i64, argv: *const i64) -> i64 {
    let clos_ptr = clos_raw as *mut Closure;
    if clos_ptr.is_null() {
        eprintln!("fatal: closure_apply on null pointer");
        abort();
    }

    let src = &*clos_ptr;
    let total = src.arity as usize;
    let have  = src.applied as usize;

    let mut args = Vec::with_capacity(have + argc as usize);
    args.extend_from_slice(&src.args);
    for i in 0..(argc as usize) {
        args.push(*argv.add(i));
    }

    let got = args.len();

    if got < total {
        let new_clos = Closure {
            code: src.code,
            arity: src.arity,
            applied: got as i64,
            args,
        };
        Box::into_raw(Box::new(new_clos)) as i64
    } else if got == total {
        call_with_i64_args(src.code, &args)
    } else {
        let (first, rest) = args.split_at(total);
        let res = call_with_i64_args(src.code, first);

        if rest.is_empty() {
            return res;
        }

        let next_clos_raw = res;
        closure_apply(next_clos_raw, rest.len() as i64, rest.as_ptr())
    }
}
