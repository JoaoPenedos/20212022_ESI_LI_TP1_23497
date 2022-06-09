Explicação passo-a-passo de como colocar a funcionar a script em diferentes máquinas
Ter em atenção as notas que se encontram no final do ficheiro


1ºPasso - Dentro da pasta onde se encontra a script encontra-se também um ficheiro chamado "credentials.txt", 
    neste ficheiro terá de colocar o email na primeria linha e a password desse email na segunda, de forma a 
    que a script consiga aceder a conta pra enviar a mensagem (*Nota-1*)

2ºPasso - Na linha 111 e 112 onde se encontra o caminho do executavel powershell, deve colocar o caminho do 
    executavel powershell que deseja utilizar, no caso do powershell 5.1 chega "powershell.exe".

3ºPasso - Para correr o agendar das tarefas deve, na linha de comandos, se colocar no caminho da pasta onde 
    se encontra a script (*Nota-2*), de seguida corra ". .\scriptPS.ps1 ScheduleTask". Se tudo correr bem 
    deverá aparecer uma tarefa criada com o nome de "ScriptPS".
    
    Caso queira testar as funções separadamente terá que correr ". .\scriptPS.ps1 MoveDir" (Copiar diretoria
     e enviar mail), e ". .\scriptPS.ps1 GetSysInf" (Informação sobre o PC), sempre em atenção a (*Nota-2*)


4ºPasso - Se quiser testar a script sem ter que esperar pelo tempo em que esta foi agendada pode correr 
    "Start-ScheduledTask -TaskName ScriptPS" ou pela propria script ". .\scriptPS.ps1 testing", esta última 
    deverá ter em atenção a (*Nota-2*)
    



*Nota-1*: o email colocado no ficheiro deve ter a segurança para aplicações não seguras desativada, pode fazer isso em: 
    "myaccount.google.com/lesssecureapps"

*Nota-2*: exemplo, se a script encontra-se em "C:\Trabalho1\script.ps1" deverá se colocar em "C:\Trabalho1"