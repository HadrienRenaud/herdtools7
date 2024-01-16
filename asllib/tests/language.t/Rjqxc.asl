// RUN: interp %s | FileCheck %s
// CHECK-NOT: Run

func main() => integer
begin
    while FALSE do
        println("Run");
    end
    return 0;
end
