// RUN: interp %s | FileCheck %s
// CHECK: a

type a of exception{};

func main() => integer
begin
    try
        try
            throw a{};
        catch
            when a => throw;
        end
    catch
        when a => println("a");
    end
    return 0;
end
