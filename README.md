# SQL 첫걸음






# DBeaver를 활용한 Analytical SQL

* https://dbeaver.io/download/
* dump file: 




# Postgresql
* https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
* 14.2 version
* Database --> new database 연결 --> Postgresql --> password 입력할 것
password 오류가 난다. 재설치하면서 password를 재설정.
postgresql이 10버전과 14버전이 동시에 존재하고 있었어서, 14버전을 install하면서 설정했던 password가 틀렸다고 나온 것 같아서,
10버전을 지워주고 14버전을 DBeaver에 연결해주려고 한다.

문제 :Unable to connect to server: could not connect to server: Connection refused (0x0000274D/10061) Is the server running on host "localhost" (::1) and accepting TCP/IP connections on port 5432? could not connect to server: Connection refused (0x0000274D/10061) Is the server running on host "localhost" (127.0.0.1) and accepting TCP/IP connections on port 5432?

오류가 생성됨. 

https://stackoverflow.com/questions/40532399/unable-to-connect-to-server-for-postgres
해당 페이지에서 10버전을 생성했을 때 포트번호를 5432로 지정해주었기 때문에 14 버전을 설치했을 때 5433으로 자동 설정되었음. 그러므로 ppostgresql.conf 파일에서 port번호를 5432로 변경해준 후 서비스에서 재시작하고나니 연결이 됨.

* sql script에 깨짐 현상이 발생하는 경우에는 vscode에서 스크립트를 열어놓은 후 utf-8 포맷에서 EUC-KR 포맷으로 변경한 후 복사 붙여넣기 해준다.
