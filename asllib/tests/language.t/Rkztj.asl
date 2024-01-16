// RUN: interp %s | FileCheck %s
// CHECK: 0
// CHECK-NEXT: 3

func main() => integer
begin
    println("0");
    if FALSE then
        println("1");
    elsif FALSE then
        println("2");
    end
    println("3");
    return 0;
end
