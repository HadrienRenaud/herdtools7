// RUN: interp %s | FileCheck %s
// CHECK: Hello
// CHECK-NEXT: World
func main() => integer
begin
    try
        println("Hello");
    catch
        when integer => pass;
    end
    println("World");
    return 0;
end
