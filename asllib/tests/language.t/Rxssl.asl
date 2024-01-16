// RUN: interp %s | FileCheck %s
// CHECK: 2

func main() => integer
begin
    if FALSE then
        println("1");
    else
        println("2");
    end
    return 0;
end
