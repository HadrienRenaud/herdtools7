// RUN: interp %s | FileCheck %s

type a of exception{
    b: integer
};

func main() => integer
begin
    var aa : a;
    var bb : integer = aa.b;

    println("" ++ bb);

    return 0;
end
