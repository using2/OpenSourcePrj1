# OSS Project 1
각 메뉴들을 출력한 후 입력받는 메뉴 번호마다 해당 기능을 수행합니다.

## 파일
* u.item (movie 정보 저장. (movie id | movie title | release date | video release date |IMDb URL |Genre…)) (1682 rows)
* u.data (사용자별 시청 영화의 평가 정보 저장. (user id  movie id  rating  timestamp)) (100000 rows)
* u.user (사용자 정보 저장. (user id | age | gender | occupation | zip code)) (943rows)

## 구성
첫번째에는 각 메뉴들과 학번, 이름을 보여주기 위해 echo 를 통해 출력합니다.
이후 Exit을 실행해주는 9번 메뉴를 입력받을때까지 반복문을 돌도록 합니다. 
stop 변수를 생성 하였고 "n"로 초기화해준 후, until을 통해 $stop = "y"일 때까지 반복문을 돌도록 합니다.
처음에 메뉴 번호를 입력 받기 위해 read를 통해 n에 현재 메뉴 번호를 저장합니다.
case, esac를 사용해 1~9번과 default 설정을 통해 1~9 외의 메뉴는 invalid choice임을 출력해주도록 했습니다.

전체적으로 파이프를 통한 사용이 많다. 두 프로세스의 출력과 입력을 연결하여 앞선 출력을 뒤의 입력으로 받는 역할을 한다.
파이프의 이용이 많기 때문에 앞서 언급하고 뒤에서의 설명은 생략한다.


### Case 1)
사용자로부터 movie id를 입력받고 movie 정보가 들어있는 u.item 파일에서 입력받은 id에 해당하는 movie 정보를 출력한다.

![image](https://github.com/using2/OpenSourcePrj1/assets/136972840/29013524-81cf-4560-b50c-fafc96bd266e)

read를 통해 사용자로부터 movie id를 입력 받는다(mid).
awk의 옵션 -F는 'delimiter가 이것이다.' 라고 지정해주고, -v는 변수를 사용할 수 있게 한다.
* 2가지 옵션은 뒤에서 주로 쓰이기 때문에 앞으로의 설명은 생략한다.
입력받은 movie_id(mid, input_mid)가 파일의 첫번째 내용($1, movie id)과 일치할 때, 해당 줄을 출력한다.

### Case 2)
사용자로부터 action 장르의 영화 목록을 확인할 것이냐고 물어본 뒤, 해당 정보를 1부터 10줄 출력한다.

![image](https://github.com/using2/OpenSourcePrj1/assets/136972840/a9904de0-8c2d-48e6-b747-9eb95c58e253)

read를 통해 사용자로부터 확인할 것인지 여부를 체크한다.(check)
확인하여서 입력 받은 값(check)이 "y"일 때에만 해당 작업을 수행한다. 
그러기 위해서 if 문을 통해 check의 값이 "y"인지 확인한다.
이후에 awk를 통해 $7(액션 장르 칸, 값이 1이면 참임)이 1인지 확인 후 맞다면 "movie-id movie-name"을 출력한다.
10개까지 출력하기 위해서 head -n 10을 사용했다.

### Case 3)
사용자로부터 movie id를 입력받고 해당 영화의 사용자들의 평가의 평균을 계산하여 출력한다.

![image](https://github.com/using2/OpenSourcePrj1/assets/136972840/7c7f3698-7f6c-47e3-8f7d-b274b9874026)

read를 통해서 사용자로부터 movie id를 입력 받는다.(mid)
uNum(해당 영화를 평가한 사용자 명수), rating(사용자로부터 받은 평가의 합)은 모두 awk를 통해서 구한다.
u.data 파일에서 입력받은 movie_id(mid, input_mid)가 파일의 두번째 내용($2, movie id)와 일치할 때마다 
count++와 sum+=$3(rating 정보)를 연산하여 출력하고, 
tail -n 1을 통해서 해당 출력 결과 중 마지막 값을 받아 각각 uNum과 rating에 저장한다.
출력 양식을 맞춰주기 위해서 awk 사용. rating/uNum의 결과를 printf 하여 양식에 맞게 출력한다.

### Case 4)
movie 정보가 담긴 u.item 파일에서 IMDb URL 내용을 삭제할 것인지 확인하고, 삭제된 내용을 1부터 10줄 출력한다.

![image](https://github.com/using2/OpenSourcePrj1/assets/136972840/5bff58fd-73d4-4730-96ee-2534cc492867)

read를 통해 사용자로부터 삭제할 것인지 여부를 체크한다.(check)
확인하여서 입력 받은 값(check)이 "y"일 때에만 해당 작업을 수행한다. 
그러기 위해서 if 문을 통해 check의 값이 "y"인지 확인한다.
sed를 통해서 http://로 시작하는 문장을 다음 | 까지 빈 문자로 대체한다.
10개까지 출력하기 위해서 head -n 10을 사용했다.

### Case 5)
사용자로부터 사용자들의 정보를 출력할지 확인받은 후, 사용자들의 정보를 1부터 10줄 출력한다.

![image](https://github.com/using2/OpenSourcePrj1/assets/136972840/cdc6ed9c-1386-41ce-8dcb-1aa83180b462)

read를 통해 사용자로부터 사용자의 정보를 확인할 것인지 여부를 체크한다.(check)
확인하여서 입력 받은 값(check)이 "y"일 때에만 해당 작업을 수행한다. 
그러기 위해서 if 문을 통해 check의 값이 "y"인지 확인한다.
맞다면 awk를 통해서 $3(gender)의 값이 한글자로 이뤄져있기 때문에 $3=="F" gender="female", $3=="M" gender="male"한다.
이후에 해당 정보를 출력 양식에 맞게 출력해준다.
10개까지 출력하기 위해서 head -n 10을 사용했다.

### Case 6)
사용자로부터 날짜 형식을 변경할지 확인한 후, DD-MMM(String)-YYYY의 형식을 YYYYMMDD로 바꿔준다.
변경된 정보를 뒤에서부터 10줄까지 출력한다.

![image](https://github.com/using2/OpenSourcePrj1/assets/136972840/4e634e9d-430e-470a-b213-4ad758297669)

read를 통해 사용자로부터 사용자의 정보를 확인할 것인지 여부를 체크한다.(check)
확인하여서 입력 받은 값(check)이 "y"일 때에만 해당 작업을 수행한다. 
그러기 위해서 if 문을 통해 check의 값이 "y"인지 확인한다
우선 sed를 통해 u.item에서 DD_MMM_YYYY의 내용을 패턴을 통해 YYYY-MMM-DD로 바꿔주었다.
이후에 -MMM- 부분을 맞는 숫자로 변경하여 YYYYMMDD 형식을 맞춰주었다.
그러면 바뀐 문자열에 | YYYYMMDD|로 공백이 생겨 공백을 제거해주기 위해 sed를 한번 더 사용해준다.
뒤에서 10개를 출력하기 위해서 tail -n 10을 사용했다.

### Case 7)
사용자로부터 usre_id를 입력 받고 해당 사용자가 평가한 모든 movie_id를 |를 delimiter로 출력한다.
그리고 해당 movie_id 중 앞에서부터 10개에 해당하는 movie의 정보를 출력해준다.

![image](https://github.com/using2/OpenSourcePrj1/assets/136972840/0f731855-474d-4a52-a5cf-38fee1f59719)

첫번째 awk는 u.data에서 사용자로부터 입력받는 user_id(uid, input_uid)와 일치하는 값($1)을 가지고 있는 열에서 
movie_id($2)를 출력하도록 한다. 이것을 midList에 저장한다.
* 해당 사용자가 평가한 영화의 목록이 공백을 기준으로 저장된 것이다.
다음으로 sort를 이용해서 midList를 정렬해준다. 정렬된 내용을 sorted에 저장한다.
movie_id가 오름차순으로 정렬된다. -n 옵션은 숫자로 정렬하겠다는 옵션이다.
두번째 awk는 정렬되어 공백을 기준으로 나뉘어져있는 문자열의 delimiter를 |로 바꾸어서 다시 midList에 저장한다.
마지막으로 마지막에 한번 더 들어가 있는 |를 지워서 sorted에 저장한다.

이후에 반복문을 1~10까지 돌면서 첫번째, 두번째, ..., 열번째 칸에 있는 movie_id를 읽어오도록 한다.
이를 movies에 저장하고, u.item에서 앞에서 받아온 movie_id(movies)와 일치하는 열의 정보를 받아와서 출력하도록 한다.
앞서 10개에 해당하는 정보를 출력하도록 하였기 때문에 반복문의 범위를 저렇게 설정한 것이다.

### Case 8)
사용자로부터 20~29세인 프로그래머들의 평가의 평균을 볼 것인지 확인받은 후, 해당 내용을 모두 출력한다.

![image](https://github.com/using2/OpenSourcePrj1/assets/136972840/7887c58f-6d9a-4261-b014-b6f7ea41bb5a)

우선 u.user 파일에서 age가 20이상, 29 이하이며 occupation이 programmer로 저장되어있는 user들의 목록을 users에 저장한다.
lines는 해당 user들의 목록의 줄 수이다. wc -l을 사용한다.
while문을 통해서 각 line의 해당하는 사용자의 user_id를 user에 저장하고,
이를 기반으로 u.data에서 해당 user가 작성한 rating 정보를 모두 datas에 저장한다.
반복문을 돌면서 계속하여 datas에 내용이 append되는 형식으로 저장하기 때문에 
반복문이 끝나고 난 후에 datas에는 해당하는 사용자들이 평가한 영화들의 정보만이 남아있을 것이다.

마지막 awk 에서 배열을 통해서 해당 movie_id의 sum, count 배열 칸에 각 값을 += $3, ++ 연산을 하여 
각 movie_id에 sum, count를 구하고 END를 사용하여 마지막에 나눈 값을 출력한다.
이 문장은 정렬되지 않은 상태이기 때문에 sort를 사용하여 movie_id를 기준으로 정렬하도록 하고,
배열이기에 0번째 칸부터 출력된다는 점을 감안하여 tail -n +2를 이용하여 2번째 열부터 출력되도록 하였다.

### Case 9) 종료

![image](https://github.com/using2/OpenSourcePrj1/assets/136972840/c59fc115-7b56-47b5-b52f-d0cab034d4ea)

앞서 언급한 것처럼 Bye!를 출력하고 stop을 "y"로 바꾸어 until문을 나갈 수 있도록 한다.


### default) 존재하지 않는 메뉴 번호

![image](https://github.com/using2/OpenSourcePrj1/assets/136972840/9220cff9-028c-4620-850f-c014cf12da82)








