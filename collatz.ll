define i32 @collatz(i32 %0){
bb0:
    %n = alloca i32
    store i32 %0, i32* %n
    br label %whileCond
whileCond:
    %t1 = load i32, i32* %n
    %t2 = icmp ne i32 %t1, 1
    br i1 %t2, label %whileBody, label %bb1
whileBody:
    %t3 = load i32, i32* %n
    %t4 = srem i32 %t3, 2
    %t5 = icmp eq i32 %t4, 0
    br i1 %t5, label %true, label %false
true:
    %t6 = load i32, i32* %n
    %t7 = sdiv i32 %t6, 2
    store i32 %t7, i32* %n
    br label %whileCond
false:
    %t8 = load i32, i32* %n
    %t9 = mul i32 %t8, 3
    %t10 = add i32 %t9, 1
    store i32 %t10, i32* %n
    br label %whileCond
bb1:
    %t11 = load i32, i32* %n
    ret i32 %t11
}

define i32 @main(){
    %r = call i32 @collatz(i32 20)
    ret i32 %r
}