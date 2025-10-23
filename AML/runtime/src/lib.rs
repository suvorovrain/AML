use std::arch::asm;
use std::io::{self, Write};
use std::mem::transmute;
use std::process::abort;

macro_rules! call_with_args {
    ($func:expr, $args_ptr:expr, $argc:expr) => {{
        let res: Value;
        match $argc {
            0 => {
                let f: extern "C" fn() -> Value = transmute($func);
                res = f();
            }
            1 => {
                let arg0 = (*$args_ptr.add(0)).clone();
                let f: extern "C" fn(Value) -> Value = transmute($func);
                res = f(arg0);
            }
            2 => {
                let arg0 = (*$args_ptr.add(0)).clone();
                let arg1 = (*$args_ptr.add(1)).clone();
                let f: extern "C" fn(Value, Value) -> Value = transmute($func);
                res = f(arg0, arg1);
            }
            3 => {
                let arg0 = (*$args_ptr.add(0)).clone();
                let arg1 = (*$args_ptr.add(1)).clone();
                let arg2 = (*$args_ptr.add(2)).clone();
                let f: extern "C" fn(Value, Value, Value) -> Value = transmute($func);
                res = f(arg0, arg1, arg2);
            }
            4 => {
                let arg0 = (*$args_ptr.add(0)).clone();
                let arg1 = (*$args_ptr.add(1)).clone();
                let arg2 = (*$args_ptr.add(2)).clone();
                let arg3 = (*$args_ptr.add(3)).clone();
                let f: extern "C" fn(Value, Value, Value, Value) -> Value = transmute($func);
                res = f(arg0, arg1, arg2, arg3);
            }
            5 => {
                let arg0 = (*$args_ptr.add(0)).clone();
                let arg1 = (*$args_ptr.add(1)).clone();
                let arg2 = (*$args_ptr.add(2)).clone();
                let arg3 = (*$args_ptr.add(3)).clone();
                let arg4 = (*$args_ptr.add(4)).clone();
                let f: extern "C" fn(Value, Value, Value, Value, Value) -> Value = transmute($func);
                res = f(arg0, arg1, arg2, arg3, arg4);
            }
            6 => {
                let arg0 = (*$args_ptr.add(0)).clone();
                let arg1 = (*$args_ptr.add(1)).clone();
                let arg2 = (*$args_ptr.add(2)).clone();
                let arg3 = (*$args_ptr.add(3)).clone();
                let arg4 = (*$args_ptr.add(4)).clone();
                let arg5 = (*$args_ptr.add(5)).clone();
                let f: extern "C" fn(Value, Value, Value, Value, Value, Value) -> Value =
                    transmute($func);
                res = f(arg0, arg1, arg2, arg3, arg4, arg5);
            }
            7 => {
                let arg0 = (*$args_ptr.add(0)).clone();
                let arg1 = (*$args_ptr.add(1)).clone();
                let arg2 = (*$args_ptr.add(2)).clone();
                let arg3 = (*$args_ptr.add(3)).clone();
                let arg4 = (*$args_ptr.add(4)).clone();
                let arg5 = (*$args_ptr.add(5)).clone();
                let arg6 = (*$args_ptr.add(6)).clone();
                let f: extern "C" fn(Value, Value, Value, Value, Value, Value, Value) -> Value =
                    transmute($func);
                res = f(arg0, arg1, arg2, arg3, arg4, arg5, arg6);
            }
            8 => {
                let arg0 = (*$args_ptr.add(0)).clone();
                let arg1 = (*$args_ptr.add(1)).clone();
                let arg2 = (*$args_ptr.add(2)).clone();
                let arg3 = (*$args_ptr.add(3)).clone();
                let arg4 = (*$args_ptr.add(4)).clone();
                let arg5 = (*$args_ptr.add(5)).clone();
                let arg6 = (*$args_ptr.add(6)).clone();
                let arg7 = (*$args_ptr.add(7)).clone();
                let f: extern "C" fn(
                    Value,
                    Value,
                    Value,
                    Value,
                    Value,
                    Value,
                    Value,
                    Value,
                ) -> Value = transmute($func);
                res = f(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
            }
            _ => {
                eprintln!("unsupported arity > 8");
                abort();
            }
        }
        res
    }};
}

// unsafe fn call_with_stack_args(func: *const (), args_ptr: *const Value, argc: usize) ->  Value {
//     assert!(argc > 8);
//     let reg_args = std::slice::from_raw_parts(args_ptr, 8);
//     let stack_args = std::slice::from_raw_parts(args_ptr.add(8), argc - 8);
//     let stack_bytes = (argc - 8) * std::mem::size_of::<Value>();

//     asm!("addi sp, sp, -{sb}", sb = in(reg) stack_bytes);

//     for (i, val) in stack_args.iter().enumerate() {
//         let offset = (i * 8) as isize;
//         asm!(
//             "sd {val}, {offset}(sp)",
//             val = in(reg) val,
//             offset = in(reg) offset,
//         );
//     }

//     let res: Value;
//     let regres:i64;
//     asm!(
//         "mv a0, {a0}",
//         "mv a1, {a1}",
//         "mv a2, {a2}",
//         "mv a3, {a3}",
//         "mv a4, {a4}",
//         "mv a5, {a5}",
//         "mv a6, {a6}",
//         "mv a7, {a7}",
//         "jalr {func}",
//         "add sp, sp, {stack_bytes}",
//         a0 = in(reg) &reg_args[0],
//         a1 = in(reg) &reg_args[1],
//         a2 = in(reg) &reg_args[2],
//         a3 = in(reg) &reg_args[3],
//         a4 = in(reg) &reg_args[4],
//         a5 = in(reg) &reg_args[5],
//         a6 = in(reg) &reg_args[6],
//         a7 = in(reg) &reg_args[7],
//         func = in(reg) func,
//         stack_bytes = in(reg) stack_bytes,
//         lateout("a0") regres,
//     );
//     res = Value::INT(regres);
//     res
// }

#[no_mangle]
pub extern "C" fn print_int(n: i64) {
    print!("{}", n);
    io::stdout().flush().unwrap()
}

#[derive(Debug, Clone)]
enum Value {
    INT(i64),
    FUN(Box<Closure>), // TODO: other types in future versions
}

// TODO: try to replace all `*const ()` with smth more safe
#[derive(Debug, Clone)]
struct Closure {
    code: *const (),
    arity: u8,
    applied_args_num: u8,
    applied_args_list: Vec<Value>,
}

extern "C" fn closure_alloc(func: *const (), arity: u8) -> *mut Closure {
    let clos: *mut Closure = Box::into_raw(Box::new(Closure {
        code: func,
        arity: arity,
        applied_args_num: 0,
        applied_args_list: Vec::new(),
    }));
    return clos;
}

extern "C" fn closure_apply(
    clos_ptr: *mut Closure,
    passed_args_num: u8,
    args_ptr: *mut Value,
) -> Value {
    let total_arity;
    let applied_args_num;
    let args_list;
    let src_func;
    unsafe {
        src_func = (*clos_ptr).code;
        total_arity = (*clos_ptr).arity;
        applied_args_num = (*clos_ptr).applied_args_num;
        args_list = (*clos_ptr).applied_args_list.clone();
    };
    let result;
    if (applied_args_num + passed_args_num) < total_arity {
        let clos = closure_alloc(src_func, total_arity);
        unsafe {
            (*clos).applied_args_num = applied_args_num + passed_args_num;
            for v in args_list {
                (*clos).applied_args_list.push(v.clone());
            }
            result = Value::FUN(Box::from_raw(clos));
            return result;
        }
    } else if (applied_args_num + passed_args_num) == total_arity {
        unsafe {
            match passed_args_num {
                0..=8 => call_with_args!(src_func, args_ptr, passed_args_num),
                _ => call_with_args!(src_func, args_ptr, passed_args_num), // TODO: with stack
            }
        }
    } else {
        eprintln!(
            "fatal: over-application detected (arity = {}, got = {})",
            total_arity,
            applied_args_num + passed_args_num
        );
        abort();
    }
}
