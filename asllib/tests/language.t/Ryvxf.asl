// RUN: interp %s | FileCheck %s
// CHECK: a

type a of exception{};
type b of exception{};
type c of exception{};

func main() => integer
begin
    try
        throw a{};
    catch
        when a => println("a");
        when b => println("b");
        otherwise => println("other");
    end

    return 0;
end
