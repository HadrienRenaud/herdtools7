// RUN: interp %s | FileCheck %s
// CHECK: b
// CHECK-NEXT: a
// CHECK-NEXT: other

type a of exception{};
type b of exception{};
type c of exception{};

func main() => integer
begin
    try
        throw b{};
    catch
        when a => println("a");
        when b => println("b");
        otherwise => println("other");
    end

    try
        throw a{};
    catch
        when a => println("a");
        when b => println("b");
        otherwise => println("other");
    end

    try
        throw c{};
    catch
        when a => println("a");
        when b => println("b");
        otherwise => println("other");
    end
    return 0;
end
