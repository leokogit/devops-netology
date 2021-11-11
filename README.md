## Домашние задания по курсу “DEVSYS-PDC-2 DevOps-инженер”. Кожаев Л.С.
### ДЗ 02-git-04-tools. Инструменты Git

#### 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
##### Вариант 1
>`$ git log --pretty=format:"%H # %s %d" | grep '^aefea'`  
> 
>aefead2207ef7e2aa5dc81a34aedf0cad4c32545 # Update CHANGELOG.md

##### Вариант 2
>`$ git rev-list --all --pretty=format:"%H # %s %d" | grep "^aefea"`  
>
>aefead2207ef7e2aa5dc81a34aedf0cad4c32545 # Update CHANGELOG.md
---
#### 2. Какому тегу соответствует коммит 85024d3?

>`$ git show -s --pretty=format:"%H # %s %d" 85024d3`  
> 
> 85024d3100126de36331c6982bfaac02cdab9e76 # v0.12.23  **(tag: v0.12.23)**
---
#### 3.  Сколько родителей у коммита b8d720? Напишите их хеши.

##### Вариант 1

>`$ git rev-parse b8d720^@` 
>   
>56cd7859e05c36c06b56d013b55a252d0bb7e158 
>9ea88f22fc6269854151c571162c5bcf958bee2b

##### Вариант 2

>`$ git show --pretty=format:"%p" b8d720`
>  
>56cd7859e 9ea88f22f

##### Вариант 3

>`$ git cat-file -p b8d720 | grep parent`
>  
>parent 56cd7859e05c36c06b56d013b55a252d0bb7e158    
>parent 9ea88f22fc6269854151c571162c5bcf958bee2b

>`$ git cat-file commit b8d720 | grep parent | wc -l` 

> 2
---
#### 4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

>`$ git log --oneline v0.12.23..v0.12.24` 
> 
>33ff1c03b (tag: v0.12.24) v0.12.24   
>b14b74c49 [Website] vmc provider links  
>3f235065b Update CHANGELOG.md   
>6ae64e247 registry: Fix panic when server is unreachable  
>5c619ca1b website: Remove links to the getting started guide's old location 
>06275647e Update CHANGELOG.md 
>d5f9411f5 command: Fix bug when using terraform login on Windows  
>4b6d06cc5 Update CHANGELOG.md 
>dd01a3507 Update CHANGELOG.md 
>225466bc3 Cleanup after v0.12.23 release 
---
#### 5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).

>`$ git log -S 'func providerSource' -p --name-only --oneline --pretty=format:"%H %ad"`
>
>5af1e6234ab6da412fb8637393c5a17a1b293663 Tue Apr 21 16:28:59 2020 -0700  
>provider_source.go**   
>**8c928e83589d90a031f811fae52a81be7153e82f Thu Apr 2 18:04:39 2020 -0700**     
>provider_source.go   

>`$ git log -L :'func providerSource':provider_source.go | grep -e "func providerSource" -e "commit" -e "Date"`
>
>commit 5af1e6234ab6da412fb8637393c5a17a1b293663  
>Date:   Tue Apr 21 16:28:59 2020 -0700   
>\-func providerSource(services *disco.Disco) getproviders.Source {      
>+func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {**  
>commit 92d6a30bb4e8fbad0968a9915c6d90435a4a08f6  
>Date:   Wed Apr 15 11:48:24 2020 -0700 
>func providerSource(services *disco.Disco) getproviders.Source { 
>**commit 8c928e83589d90a031f811fae52a81be7153e82f**  
>Date:   Thu Apr 2 18:04:39 2020 -0700  
>+func providerSource(services *disco.Disco) getproviders.Source {  
>
---
#### 6. Найдите все коммиты в которых была изменена функция globalPluginDirs.

>`$ git log -G 'globalPluginDirs' --oneline`
> 
>22a2580e9 main: Use the new cliconfig package credentials source 
>35a058fb3 main: configure credentials from the CLI config file 
>c0b176109 prevent log output during init 
>8364383c3 Push plugin discovery down into command package  

---
#### 7. Кто автор функции synchronizedWriters?

>`$ git log -S 'synchronizedWriters' -p --name-only --oneline --pretty=format:"%an,%ar"` 
> 
>James Bardin,12 months ago 
>synchronized_writers.go  
> 
>James Bardin,1 year, 1 month ago 
>main.go  
>**Martin Atkins,4 years, 6 months ago**  
>main.go  
>synchronized_writers.go  

