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
var lista: TponteiroLista; 
    op: integer;
    palavra, traducao: string;

procedure criarLista(var l: TponteiroLista);
begin
    l:= nil;
end;

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
				resultado:= resultado + char(ord(s[i]) + 32)
			else
				resultado:= resultado + s[i];
		end;
	end;
	formatarString:= resultado;
end;

function verificaChave(l: TponteiroLista; chave: string): boolean;
begin
    while (l <> nil) and (l^.chave <> chave) do 
        l:= l^.prox;
    if l = nil then
        verificaChave:= false
    else
        verificaChave:= true;
end;

function verificaVerbete(d: TponteiroDic; verbete: string): boolean;
begin
    while (d <> nil) and (d^.portugues <> verbete) do
        d:= d^.prox;
    if d = nil then
        verificaVerbete:= false
    else
        verificaVerbete:= true;
end;

procedure inserirChave(var l: TponteiroLista; chave: string);
var novo, aux, temp: TponteiroLista;
begin
    new(novo);
    if novo <> nil then
    begin
        if not verificaChave(l, chave) then
        begin
            novo^.chave:= chave;
            novo^.dic:= nil;
            novo^.prox:= nil;
            novo^.ant:= nil;
            if l = nil then
                l:= novo
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
                if aux^.prox = nil then
                begin
                    aux^.prox:= novo;
                    novo^.ant:= aux;
                end
                else
                begin
                    temp:= aux^.prox;
                    aux^.prox:= novo;
                    novo^.ant:= aux;
                    novo^.prox:= temp;
                    temp^.ant:= novo;
                end;
            end;
        end
        else
            writeln('Chave ja existe');
    end
    else
        writeln('Memória cheia haha')
end;

function buscarGrupo(l: TponteiroLista; verbete: string): TponteiroLista;
begin
    while (l <> nil) and (l^.chave <= verbete) do
        l:= l^.prox;
    buscarGrupo:= l;
end;

procedure inserirVerbete(var l: TponteiroLista; verbete, traducao: string);
var novo, aux, temp: TponteiroDic;
    grupo: TponteiroLista;
begin
    grupo:= buscarGrupo(l, verbete);
    if grupo = nil then
        writeln('Não ha chave maior que ', verbete, ' Cadastre uma chave primeiro')
    else
    begin
        if not verificaVerbete(grupo^.dic, verbete) then
        begin
            new(novo);
            if novo <> nil then
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
                    temp:= aux^.prox;
                    aux^.prox:= novo;
                    novo^.prox:= temp;
                end;
                writeln('Verbete ', verbete, ' inserido no grupo de ', grupo^.chave)
            end
            else
                writeln('Memória cheia');
        end
        else
            writeln('O verbete ja existe')
    end;
end;

procedure removerVerbete(var l: TponteiroLista; verbete: string);
var grupo: TponteiroLista;
    aux, temp: TponteiroDic;
begin
    grupo:= buscarGrupo(l, verbete);
    if grupo = nil then
        writeln('Não há grupo para ', verbete)
    else if grupo^.dic = nil then
        writeln('Grupo sem verbetes')
    else if grupo^.dic^.portugues = verbete then
    begin
        temp:= grupo^.dic;
        grupo^.dic:= grupo^.dic^.prox;
        dispose(temp);
    end
    else
    begin
        aux:= grupo^.dic;
        while (aux^.prox <> nil) and (aux^.prox^.portugues <> verbete) do
            aux:= aux^.prox;
        if aux^.prox = nil then
            writeln('Verbete não encontrado')
        else
        begin
            temp:= aux^.prox;
            aux^.prox:= aux^.prox^.prox;
            dispose(temp);
        end;
    end;
end;
        
procedure removerChave(var l: TponteiroLista; chave: string);
var aux, temp: TponteiroLista;
    verbete: TponteiroDic;
begin
    if l = nil then
        writeln('Lista vazia')
    else if l^.chave = chave then
    begin
        if l^.prox = nil then
            writeln('Não é possível remover a única chave')
        else
        begin
            temp:= l;
            if temp^.dic <> nil then
            begin
                verbete:= temp^.dic;
                while verbete^.prox <> nil do
                    verbete:= verbete^.prox;
                verbete^.prox:= l^.prox^.dic;
                l^.prox^.dic:= temp^.dic;
            end;
            l:= l^.prox;
            l^.ant:= nil;
            dispose(temp);
        end;
    end
    else
    begin
        aux:= l;
        while (aux^.prox <> nil) and (aux^.prox^.chave <> chave) do
            aux:= aux^.prox;
        if aux^.prox = nil then
            writeln('Chave não encontrada')
        else
        begin
            temp:= aux^.prox;
            if temp^.dic <> nil then
            begin
                if temp^.prox <> nil then
                begin
                    verbete:= temp^.dic;
                    while verbete^.prox <> nil do
                        verbete:= verbete^.prox;
                    verbete^.prox:= temp^.prox^.dic;
                    temp^.prox^.dic:= temp^.dic;
                end
                else
                begin
                    verbete:= aux^.dic;
                    if verbete = nil then
                        aux^.dic:= temp^.dic
                    else
                    begin
                        while verbete^.prox <> nil do
                            verbete:= verbete^.prox;
                        verbete^.prox:= temp^.dic;
                    end;
                end;
            end;
            aux^.prox:= temp^.prox;
            if temp^.prox <> nil then
                temp^.prox^.ant:= aux;
            dispose(temp)
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
            writeln('Verbete não encontrado')
        else
            writeln(aux^.portugues, ' -> ', aux^.ingles);
    end;
end;
        
procedure escreverTudo(l: TponteiroLista);
var verbete: TponteiroDic;
begin
    if l = nil then
        writeln('Dicionário vazio')
    else
    begin
        while l <> nil do
        begin
            writeln(l^.chave);
            verbete:= l^.dic;
            if verbete = nil then
                writeln(' Sem verbetes')
            else
            begin
                while verbete <> nil do
                begin
                    writeln(' ', verbete^.portugues, ' -> ', verbete^.ingles);
                    verbete:= verbete^.prox;
                end;
            end;
            l:= l^.prox;
        end;
    end;
end;


begin
    criarLista(lista);
    op := 0;
    while op <> 7 do
    begin
        writeln;
        writeln('1 - Inserir chave');
        writeln('2 - Inserir verbete');
        writeln('3 - Remover verbete');
        writeln('4 - Remover chave');
        writeln('5 - Consultar');
        writeln('6 - Escrever tudo');
        writeln('7 - Sair');
        write('Opcao: ');
        readln(op);
        case op of
            1: begin
                write('Chave: ');
                readln(palavra);
                palavra := formatarString(palavra);
                inserirChave(lista, palavra);
            end;
            2: begin
                write('Verbete: ');
                readln(palavra);
                write('Traducao: ');
                readln(traducao);
                palavra := formatarString(palavra);
                traducao := formatarString(traducao);
                inserirVerbete(lista, palavra, traducao);
            end;
            3: begin
                write('Verbete a remover: ');
                readln(palavra);
                palavra := formatarString(palavra);
                removerVerbete(lista, palavra);
            end;
            4: begin
                write('Chave a remover: ');
                readln(palavra);
                palavra := formatarString(palavra);
                removerChave(lista, palavra);
            end;
            5: begin
                write('Verbete a consultar: ');
                readln(palavra);
                palavra := formatarString(palavra);
                consultar(lista, palavra);
            end;
            6: escreverTudo(lista);
            7: writeln('Saindo...');
        else
            writeln('Opcao invalida');
        end;
    end;
end.