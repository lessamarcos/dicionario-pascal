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

procedure inserirVerbete(var l: tLista; p: string; verbete: string);
var novo, temp, temp2: TponteiroDIc;
	aux: Tponteiro;
begin
	new(novo);
	if novo <> nil then
	begin
		aux:= l.inicio;
		novo^.verbete:= verbete;
		novo^.prox:= nil;
		while (aux <> nil) and (aux^.palavra <> p) do
			aux:= aux^.prox;
		if aux^.palavra = p then
		begin
			if aux^.dic = nil then
				aux^.dic:= novo
			else if verbete < aux^.dic^.verbete then
			begin
				temp:= aux^.dic;
				aux^.dic:= novo;
				aux^.dic^.prox:= temp;
			end
			else
			begin
				temp:= aux^.dic;
				while (temp^.prox <> nil) and (temp^.prox^.verbete < verbete) do
					temp:= temp^.prox;
				temp2:= temp^.prox;
				temp^.prox:= novo;
				novo^.prox:= temp2;
			end;
		end
		else
			writeln('Palavra não encontrada');
	end
	else
		writeln('Memória cheia');
end;

procedure removerVerbete(var l: lista; p: string; verbete: string);
var aux: Tponteiro;
	temp, temp2: TponteiroDIc;
begin
	if verificaVazio(l) then
		writeln('Lista de palavras vazia')
	else
	begin
		aux:= l.inicio;
		while (aux <> nil) and (aux^.palavra <> p) do
			aux:= aux^.prox;
		if aux = nil then
			writeln('Palavra não encontrada')
		else if aux^.dic^.verbete = verbete then
		begin
			temp:= aux^.dic;
			aux^.dic:= aux^.dic^.prox;
			dispose(temp);
		end
		else
		begin
			temp:= aux^.dic;
			while (temp^.prox <> nil) and (temp^.prox^.verbete <> verbete) do
				temp:= temp^.prox;
			if temp^.prox = nil then
				writeln('O verbete não está na lista')
			else
			begin
				temp2:= temp^.prox;
				temp^.prox:= temp^.prox^.prox;
				dispose(temp2);
			end;
		end;
	end;
end;

procedure consultar(l: Tlista; p: string);
var aux: Tponteiro;
	temp: TponteiroDic;
begin
	if verificaVazio(l) then
		writeln('Lista vazia')
	else
	begin
		aux:= l.inicio;
		while (aux <> nil) and (aux^.palavra <> p) do
			aux:= aux^.prox;
		if aux = nil then
			writeln('Palavra não encontrada')
		else
		begin
			temp:= aux^.dic;
			while (temp <> nil) do
			begin
				write(temp^.verbete, ' ');
				temp:= temp^.prox;
			end;
		end;
	end;
end;
		
procedure escreverTudo(l: tlista);
var aux: Tponteiro;
	temp: TponteiroDic;
begin
	if verificaVazio(l) then
		writeln('Lista vazia')
	else
	begin
		aux:= l.inicio;
		while (aux <> nil) do
		begin
			writeln(aux^.palavra, ' :');
			temp:= aux^.dic;
			while (temp <> nil) do
			begin
				write(temp^.verbete, ', ');
				temp:= temp^.prox;
			end;
			aux:= aux^.prox;
		end;
	end;
end;