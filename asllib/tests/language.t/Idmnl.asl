// RUN: interp %s | FileCheck %s
// CHECK: TRUE
// CHECK-NEXT: TRUE

func main() => integer
begin
    var a: string = "Hello";
    println("" ++ (a == "Hello"));
    println("" ++ (a != "World"));
    return 0;
end
