use std::io::{self, Write};

#[no_mangle]
pub extern "C" fn print_int(n: i64) {
    print!("{}", n);
    io::stdout().flush().unwrap()
}

#[derive (Debug)]
enum Value {
    INT(i64),
    FUN(Box<Closure>)
    // TODO: other types in future versions
}
#[derive (Debug)]
struct Closure {
    code: *const (),
    arity: u8,
    applied_args_num: u8,
    applied_args_list: Vec<Value>, 
}