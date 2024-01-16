// RUN: interp %s | FileCheck %s
// CHECK: TRUE

func main() => integer
begin
    var a: bits(2);
    println("" ++ (a == '00'));
    return 0;
end
