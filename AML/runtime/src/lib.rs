
#[no_mangle]
pub extern "C" fn aml_print_int(n: i64) {
    println!("{}", n);
}
