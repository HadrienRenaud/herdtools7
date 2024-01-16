// RUN: interp %s | FileCheck %s
// CHECK: 10

config a: integer = 10;

func main() => integer
begin
    println("" ++ a);
    return 0;
end
