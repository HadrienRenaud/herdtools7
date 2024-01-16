// RUN: interp %s | FileCheck %s
// CHECK: TRUE
// CHECK-NEXT: TRUE
// CHECK-NEXT: FALSE
// CHECK-NEXT: TRUE
// CHECK-NEXT: Hello
// CHECK-NEXT: World
// CHECK-NEXT: FALSE
// CHECK-NEXT: World
// CHECK-NEXT: TRUE


func true_writer() => boolean
begin
    println("Hello");
    return TRUE;
end

func false_writer() => boolean
begin
    println("World");
    return FALSE;
end

func main() => integer
begin
    println("" ++ FALSE --> FALSE);
    println("" ++ FALSE --> TRUE);
    println("" ++ TRUE --> FALSE);
    println("" ++ TRUE --> TRUE);

    var a: boolean = true_writer() --> false_writer();
    println("" ++ a);


    var b: boolean = false_writer() --> false_writer();
    println("" ++ b);
    return 0;
end
