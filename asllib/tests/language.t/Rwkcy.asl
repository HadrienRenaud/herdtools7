// RUN: interp %s | FileCheck %s
// CHECK:

func main() => integer
begin
    var a: string;
    println(a);
    return 0;
end
