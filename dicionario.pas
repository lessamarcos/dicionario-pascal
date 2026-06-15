program dicionario;
type
    TponteiroDic = ^dic;
    dic = record
        portugues: string;
        ingles: string;
        prox: TponteiroDic;
    end;

    TponteiroLista = ^no;
    no = record
        ant: TponteiroLista;
        chave: string;
        dic: TponteiroDic;
        prox: TponteiroLista;
    end;
var lista, fim: TponteiroLista;
    op: integer;
    palavra, traducao: string;

function formatarString(s: string): string;
var i: integer;
	resultado: string;
begin
	resultado:= '';
	if length(s) > 0 then
	begin
		resultado:= upcase(s[1]);
		for i:= 2 to length(s) do
		begin
			if (s[i] >= 'A') and (s[i] <= 'Z') then
				resultado:= resultado + chr(ord(s[i]) + 32)
			else
				resultado:= resultado + s[i];
		end;
	end;
	formatarString:= resultado;
end;

function verificaChave(l: TponteiroLista; chave: string): boolean;
begin
    while (l <> nil) and (l^.chave < chave) do
        l:= l^.prox;
    verificaChave:= (l <> nil) and (l^.chave = chave);
end;

function verificaVerbete(d: TponteiroDic; verbete: string): boolean;
begin
    while (d <> nil) and (d^.portugues < verbete) do
        d:= d^.prox;
    verificaVerbete:= (d <> nil) and (d^.portugues = verbete);
end;

procedure inserirChave(var l: TponteiroLista; var fim: TponteiroLista; chave: string);
var novo, aux: TponteiroLista;
    ultimoMenor: TponteiroDic;
begin
    if verificaChave(l, chave) then
        writeln('Chave ja existe')
    else
    begin
        new(novo);
        if novo = nil then
            writeln('Memória cheia hahaha')
        else
        begin
            novo^.chave:= chave;
            novo^.dic:= nil;
            novo^.prox:= nil;
            novo^.ant:= nil;
            if l = nil then
            begin
                l:= novo;
                fim:= novo;
            end
            else if chave < l^.chave then
            begin
                novo^.prox:= l;
                l^.ant:= novo;
                l:= novo;
            end
            else
            begin
                aux:= l;
                while (aux^.prox <> nil) and (aux^.prox^.chave < chave) do
                    aux:= aux^.prox;
                novo^.prox:= aux^.prox;
                novo^.ant:= aux;
                if aux^.prox <> nil then
                    aux^.prox^.ant:= novo
                else
                    fim:= novo;
                aux^.prox:= novo;
                if aux^.dic <> nil then
                begin
                    if aux^.dic^.portugues >= chave then
                    begin
                        novo^.dic:= aux^.dic;
                        aux^.dic:= nil;
                    end
                    else
                    begin
                        ultimoMenor:= aux^.dic;
                        while (ultimoMenor^.prox <> nil) and (ultimoMenor^.prox^.portugues < chave) do
                            ultimoMenor:= ultimoMenor^.prox;
                        novo^.dic:= ultimoMenor^.prox;
                        ultimoMenor^.prox:= nil;
                    end;
                end;
            end;
            writeln('Chave ', chave, ' inserida');
        end;
    end;
end;

function buscarGrupo(l: TponteiroLista; verbete: string): TponteiroLista;
var grupo: TponteiroLista;
begin
    grupo:= nil;
    while (l <> nil) and (l^.chave <= verbete) do
    begin
        grupo:= l;
        l:= l^.prox;
    end;
    buscarGrupo:= grupo;
end;

procedure inserirVerbete(var l: TponteiroLista; verbete, traducao: string);
var novo, aux: TponteiroDic;
    grupo: TponteiroLista;
begin
    grupo:= buscarGrupo(l, verbete);
    if grupo = nil then
        writeln('Nao ha chave menor ou igual a ', verbete, '. Cadastre uma chave primeiro')
    else if verificaVerbete(grupo^.dic, verbete) then
        writeln('O verbete ja existe')
    else
    begin
        new(novo);
        if novo = nil then
            writeln('Memória cheia haha')
        else
        begin
            novo^.portugues:= verbete;
            novo^.ingles:= traducao;
            novo^.prox:= nil;
            if grupo^.dic = nil then
                grupo^.dic:= novo
            else if verbete < grupo^.dic^.portugues then
            begin
                novo^.prox:= grupo^.dic;
                grupo^.dic:= novo;
            end
            else
            begin
                aux:= grupo^.dic;
                while (aux^.prox <> nil) and (aux^.prox^.portugues < verbete) do
                    aux:= aux^.prox;
                novo^.prox:= aux^.prox;
                aux^.prox:= novo;
            end;
            writeln('Verbete ', verbete, ' inserido no grupo de ', grupo^.chave);
        end;
    end;
end;

procedure removerVerbete(var l: TponteiroLista; verbete: string);
var grupo: TponteiroLista;
    aux, temp: TponteiroDic;
begin
    grupo:= buscarGrupo(l, verbete);
    if grupo = nil then
        writeln('Nao ha grupo para ', verbete)
    else if grupo^.dic = nil then
        writeln('Grupo sem verbetes')
    else if grupo^.dic^.portugues = verbete then
    begin
        temp:= grupo^.dic;
        grupo^.dic:= grupo^.dic^.prox;
        dispose(temp);
        writeln('Verbete ', verbete, ' removido');
    end
    else
    begin
        aux:= grupo^.dic;
        while (aux^.prox <> nil) and (aux^.prox^.portugues <> verbete) do
            aux:= aux^.prox;
        if aux^.prox = nil then
            writeln('Verbete nao encontrado')
        else
        begin
            temp:= aux^.prox;
            aux^.prox:= aux^.prox^.prox;
            dispose(temp);
            writeln('Verbete ', verbete, ' removido');
        end;
    end;
end;

procedure moverVerbetes(var destino: TponteiroDic; origem: TponteiroDic);
var aux: TponteiroDic;
begin
    if destino = nil then
        destino:= origem
    else if origem <> nil then
    begin
        aux:= destino;
        while aux^.prox <> nil do
            aux:= aux^.prox;
        aux^.prox:= origem;
    end;
end;

procedure removerChave(var l: TponteiroLista; var fim: TponteiroLista; chave: string);
var aux, temp: TponteiroLista;
begin
    if l = nil then
        writeln('Lista vazia')
    else if l^.chave = chave then
    begin
        if l^.dic <> nil then
            writeln('Nao e possivel remover a primeira chave enquanto houver verbetes nela. Remova os verbetes primeiro.')
        else
        begin
            temp:= l;
            l:= l^.prox;
            if l <> nil then
                l^.ant:= nil
            else
                fim:= nil;
            dispose(temp);
            writeln('Chave ', chave, ' removida');
        end;
    end
    else
    begin
        aux:= l;
        while (aux^.prox <> nil) and (aux^.prox^.chave <> chave) do
            aux:= aux^.prox;
        if aux^.prox = nil then
            writeln('Chave nao encontrada')
        else
        begin
            temp:= aux^.prox;
            moverVerbetes(aux^.dic, temp^.dic);
            aux^.prox:= temp^.prox;
            if temp^.prox <> nil then
                temp^.prox^.ant:= aux
            else
                fim:= aux;
            dispose(temp);
            writeln('Chave ', chave, ' removida');
        end;
    end;
end;

procedure consultar(l: TponteiroLista; verbetePt: string);
var grupo: TponteiroLista;
    aux: TponteiroDic;
begin
    grupo:= buscarGrupo(l, verbetePt);
    if grupo = nil then
        writeln('Nenhum grupo encontrado para ', verbetePt)
    else
    begin
        aux:= grupo^.dic;
        while (aux <> nil) and (aux^.portugues <> verbetePt) do
            aux:= aux^.prox;
        if aux = nil then
            writeln('Verbete nao encontrado')
        else
            writeln(aux^.portugues, ' -> ', aux^.ingles);
    end;
end;

procedure escreverTudo(l: TponteiroLista);
var verbete: TponteiroDic;
begin
    if l = nil then
        writeln('Dicionario vazio')
    else
    begin
        while l <> nil do
        begin
            writeln(l^.chave);
            verbete:= l^.dic;
            if verbete = nil then
                writeln('  (sem verbetes)')
            else
            begin
                while verbete <> nil do
                begin
                    writeln('  ', verbete^.portugues, ' -> ', verbete^.ingles);
                    verbete:= verbete^.prox;
                end;
            end;
            l:= l^.prox;
        end;
    end;
end;

procedure escreverInverso(fim: TponteiroLista);
var verbete: TponteiroDic;
begin
    if fim = nil then
        writeln('Dicionario vazio')
    else
    begin
        while fim <> nil do
        begin
            writeln(fim^.chave);
            verbete:= fim^.dic;
            if verbete = nil then
                writeln('  (sem verbetes)')
            else
            begin
                while verbete <> nil do
                begin
                    writeln('  ', verbete^.portugues, ' -> ', verbete^.ingles);
                    verbete:= verbete^.prox;
                end;
            end;
            fim:= fim^.ant;
        end;
    end;
end;


begin
    lista:= nil;
    fim:= nil;
    repeat
        writeln;
        writeln('1 - Incluir palavra-chave');
        writeln('2 - Incluir no dicionario');
        writeln('3 - Remover do dicionario');
        writeln('4 - Consultar');
        writeln('5 - Escrever todo dicionario');
        writeln('6 - Remover palavra-chave');
        writeln('7 - Escrever invertido');
        writeln('8 - Sair');
        readln(op);
        case op of
            1: begin
                write('Palavra-chave: ');
                readln(palavra);
                palavra:= formatarString(palavra);
                inserirChave(lista, fim, palavra);
            end;
            2: begin
                write('Verbete (portugues): ');
                readln(palavra);
                write('Traducao (ingles): ');
                readln(traducao);
                palavra:= formatarString(palavra);
                traducao:= formatarString(traducao);
                inserirVerbete(lista, palavra, traducao);
            end;
            3: begin
                write('Verbete a remover: ');
                readln(palavra);
                palavra:= formatarString(palavra);
                removerVerbete(lista, palavra);
            end;
            4: begin
                write('Verbete a consultar: ');
                readln(palavra);
                palavra:= formatarString(palavra);
                consultar(lista, palavra);
            end;
            5: escreverTudo(lista);
            6: begin
                write('Chave a remover: ');
                readln(palavra);
                palavra:= formatarString(palavra);
                removerChave(lista, fim, palavra);
            end;
            7: escreverInverso(fim);
            8: writeln('Saindo...');
        else
            writeln('Opcao invalida');
        end;
    until op = 8;
end.