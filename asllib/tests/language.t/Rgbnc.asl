// RUN: interp %s | FileCheck %s
// CHECK: 0

var a: integer;

func main() => integer
begin
    println("" ++ a);

    return 0;
end
