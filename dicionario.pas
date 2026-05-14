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

