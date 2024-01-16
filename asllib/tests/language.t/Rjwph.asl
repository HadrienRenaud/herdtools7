// RUN: interp %s | FileCheck %s
// CHECK: Hello World

func main() => integer
begin
    println("Hello World");
    return 0;
end
