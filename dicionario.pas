program dicionario;
type
    TponteiroDic = ^dic;

dic = record
    verbete: string;
    prox: Tponteirodic;
end;

Tponteiro = ^no;
no = record
    palavra: string;
    dic: TponteiroDic;
    prox: Tponteiro;
    ant: Tponteiro;
end;

Tlista = record
    inicio: Tponteiro;
    fim: Tponteiro;
end;

function verificaVazio(l: tlista): boolean;
begin
    verificaVazio:= l.inicio = nil;
end;

procedure inserirPalavra(var l: Tlista; p: string)
var novo, temp, aux: Tponteiro;
begin
    new(novo);
    novo^.prox:= nil;
    novo^.ant:= nil;
    if novo <> nil then
    begin
        novo^.palavra:= p;
        if verificaVazio(l) then
        begin
            l.inicio:= novo;
            l.fim:= novo
        end
        else if p < l.inicio^.palavra then
        begin
            temp:= l.inicio;
            l.inicio:= novo;
            novo^.prox:= temp;
            temp^.ant:= novo;
        end
        else
        begin
            aux:= l.inicio;
            while (aux^.prox <> nil) and (aux^.prox^.palavra < p) do 
                aux:= aux^.prox;
            if aux^.prox = nil then
            begin
                aux^.prox:= novo;
                novo^.ant:= aux;
                l.fim:= novo;
            end
            else
            begin
                temp:= aux^.prox;
                aux^.prox:= novo;
                novo^.prox:= temp;
                novo^.ant:= aux;
                temp^.ant:= novo;
            end;
        end;
    end
    else
        writeln('Memória cheia hahaha');
end;

