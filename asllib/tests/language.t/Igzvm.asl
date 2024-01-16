// RUN: interp %s | FileCheck %s
// CHECK: 10

type a of exception{
    aa: integer
};

type b subtypes a;

func main() => integer
begin
    try
        throw b {
            aa=10
        };
    catch
        when aa : a => println("" ++ aa.aa);

    end

    return 0;
end
