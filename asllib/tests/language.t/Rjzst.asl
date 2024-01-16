// RUN: interp %s | FileCheck %s
// CHECK: aa
// CHECK-NEXT: bb

type a of exception{};


func main() => integer
begin
    try
        throw a{};
    catch
        when a => println("aa");
    end
    println("bb");
    return 0;
end
