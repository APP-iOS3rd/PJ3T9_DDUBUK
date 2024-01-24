# **<u>DDUBUK: 뚜벅</u>**
> 내가 가보지 않은 길을 찾아보고 나만의 산책로를 공유해보자!


#### 👨‍👨‍👦‍👦 팀원

|Leader|Member|Member|Member|
|:-----------:|:-----------:|:-----------:|:------------:|
|[조민식](https://github.com/mongsik98)|[김재완](https://github.com/jaewan0091)|[이경헌](https://github.com/BOLTB0X)|[박호건](https://github.com//ghrjs1998)|
|<img src="https://avatars.githubusercontent.com/u/56242414?v=4" width="100">|<img src="https://avatars.githubusercontent.com/u/144413519?v=4" width="100">|<img src="https://avatars.githubusercontent.com/u/83914919?v=4" width="100">|<img src="https://avatars.githubusercontent.com/u/75073299?v=4" width="100">|




    
#### 팀 링크

- [📒 Notion](https://likelion.notion.site/2b296139752544f38f0e85734e3448a5)
- [📱 Figma](https://www.figma.com/file/DIAZVRUZaqLVnWy93wGgo7/DDUBUK_뚜벅-team-library?type=design&node-id=0-1&mode=design&t=RcdJ12lBuBEpC0lI-0)


#### 기술스택
```
SwiftUI
Mapkit
Combine
Health Kit
Core Location
Firebasefirestore
```


  
## 📋목차

1. [DDUBUK: 뚜벅 소개](#1-ddubuk-뚜벅-소개)
    - [프로젝트 특징](#-프로젝트-특징)
    - [기대효과](#-기대효과)
    - [향후 발전 계획](#-향후-발전-계획)
2. [발생한 이슈들 소개 ](#2-발생한-이슈들-소개)
3. [테스트 시연영상](#3-테스트-시연영상)
4. [향후 발전 계획  ](#4-향후-발전-계획)
    - [문제점](#문제점)

  

#  1. DDUBUK 뚜벅 소개
- 저희 앱은 **사용자들에게 특별한 산책 경험을 제공**하는 산책 관련 어플리케이션입니다. 
- 🚶‍♂️ 애플의 **MapKit을 활용**하여 **<u>현재 위치를 기반으로 한 메인 산책 스팟을 지도에서 손쉽게 확인하고,  
해당  스팟까지의 추천 경로를 제공</u>** 합니다.
- 사용자는 **테마별**로 산책로를 찾아보고, 걸으면서 **다양한 경험**을 즐길 수 있습니다.




  
## * 프로젝트 특징   
- **MapKit 적용**: 사용자에게 직관적인 지도를 통해 현재 위치 근처의 산책 스팟과 추천 경로를 제시합니다.
- **다양한 테마별 산책로**: 낮, 밤, 강아지와 함께, 아이와 함께 등 다양한 테마로 산책로를 분류하여 제공합니다.
- **걷기 기록 및 만보기**: Health Kit이나 Core Motion을 활용하여 사용자의 걸음 수를 기록하고, 건강한 라이프스타일을 도울  
만보기 기능을 제공합니다.
- **커뮤니티 기능**: 사용자들은 산책로에 대한 후기와 경험을 나누며 소통할 수 있는 커뮤니티 기능이 탑재되어 있습니다.


    
## * 기대효과
- "DDUBUK : 뚜벅" 앱을 통해 사용자들은 건강을 증진하고, 다양한 테마의 산책로를 통해 여유로운 시간을 즐길 수 있습니다. 
- 더불어 커뮤니티를 통한 소통은 다양한 산책 경험을 공유하고, 함께 걸어가는 즐거움을 찾을 수 있는 기회를 제공합니다. 👣🌿


   

   
#  2. 발생한 이슈들 소개

##  Moment 1. 메인화면의 검색기능 - 유료?
- 메인화면 와이어프레임을 짜던중 유료/무료 회원에 대한 Benefit을 어떻게 줄지 논의
- 검색이라는 기능 모든유저가 다쓸수 있는 부분인지.. 아니면 대부분의 기능은 유료?  
 → 원하는 산책경로를 다운받아야 하는 경우에 일부 경로들만 오픈하고 나머지 테마는 잠금방식채택하기로 결정( 유료테마제공하는 식으로 구성예정 )

  
## Moment 2. Map Kit을 고른 과정
- 네이버 등은 자유도가 낮음 + 수도권지역은 업데이트가 빠르나 지방이나 이런 타지역은 업데이트가 느릴 수 있음 → 편집하기에는 MapKit이나 MapBox
- 실습하는 것처럼 간단하게 토큰을받아서 띄어보기 를 해보는게 나을거같다 라는 피드백 수용

|  **비교** | MapKit | MapBox |
| :---: | :---: | :---: |
| **장점** | 문서가 잘나와있다. 관련 내용들이 많아서 찾기에 편하다 | api가져오는게 편하다|
| **단점** | 기능 자체를 구현하는게 번거로울 수 있다 | 문서가 잘 안나와 있다 ( Exampleprotocol..) |
- 결론 : 배우는 입장에서 깔끔한 문서와 관련 내용이 많고, 기초적인 소스들을 다뤄보는 경험을 가질 수 있는 **MapKit**을 채택


    
##  Moment 3. 서버의 중요성(멘토링 수용부분)
- 우리 앱은 경로에 대한 부분을 저장하고 커뮤니티등에 공유가 되는게 주기능
- 즉, 위치를 찍는것보단 서버통신전달받는게 제일 중요한 부분이 됨 
- 그래서 좌표값을 받아오는 것보단 서버에서 받아서 그리는 것을 우선순위로 보고 서버구현을 우선적으로 진행시도 
- 팀원 4명이 RecordView 1명, MapView1명, Firebase2명 배치 
- 서버부분은 db설계 → 파이어스토어로 하고 → 나중에 데이터설계 공부해서 서버연동할 것임 → 
현재는 한사람용으로 만들고 → 이후 발전방향: 여러사람 → 컬렉션에 어떤 키를 넣을것인지에 대한 방안 탐구 
  



#   3. 테스트 시연영상





| 내 이동경로 표시, 액티브상태로 이동 | 기록버튼추가, 좌표틔임테스트 |
|:--:|:--:|
| [![새로운 테스트 영상](https://img.youtube.com/vi/RReHp636qNs/maxresdefault.jpg)](https://youtube.com/shorts/RReHp636qNs?feature=share) | [![새로운 테스트 영상2](https://img.youtube.com/vi/GypngpOws0I/maxresdefault.jpg)](https://youtube.com/shorts/GypngpOws0I?feature=share) |

| 백그라운드 상태로 이동 | 기록관련 컴포넌트 추가 |
|:--:|:--:|
| [![새로운 테스트 영상](https://img.youtube.com/vi/1I0z1UL0zpA/maxresdefault.jpg)](https://youtube.com/shorts/1I0z1UL0zpA?feature=share) | [![새로운 테스트 영상2](https://img.youtube.com/vi/8-0VcFxzGAY/maxresdefault.jpg)](https://youtube.com/shorts/8-0VcFxzGAY?feature=share) |

| Marker테스트 | 버튼 테스트 |
|:--:|:--:|
| [![새로운 테스트 영상1](https://img.youtube.com/vi/AYr3rHr-fEE/maxresdefault.jpg)](https://youtube.com/shorts/AYr3rHr-fEE?feature=share) | [![새로운 테스트 영상2](https://img.youtube.com/vi/G92JhbyIQME/maxresdefault.jpg)](https://youtu.be/G92JhbyIQME) |
(추후 썸네일 변경예정) |  (추후 썸네일 변경예정)

  

|서버 DB 연동 데이터구조 예시|
|:--:|
|<img src="https://github.com/APP-iOS3rd/PJ3T9_DDUBUK/assets/144413519/792ab284-b5e5-4cbe-acb7-caf3fc8719bf" width="">|


  

#  4. 보완점 및 향후 발전 계획

    
  ## <u>문제점</u> → 보완방안✔️

  
### Case1. 좌표 튀는 현상
GPS 특성상 매우 정확하게 자신의 위치를 나타내는 것이 기술임. 

<u>아이폰GPS기능으로 현재 **이동경로를 선으로 이어붙이는 것에 가끔 부정확하게 이어지는 것**이 발견 </u>


  
### Case2. 이동거리 계산의 정확성이 떨어짐
현재는 저장된 위도, 경도를 통해 이동거리를 계산해서 사용자에게 표기

하지만 <u>이 이동거리는 **좌표가 틜수 있는 위도, 경도로 계산된 결과**라 정확한 거리라 말하기 애매</u>

예시) 내가 이동경로 기록하다 잠시 멈쳤을 경우 디바이스에선 연산이 아직 마무리 안된 경우도 있어 계속해서 연산이 진행되어 이동거리가 늘어나는 현상을 확인

```
업데이트 주기 변경 및 좌표 저장 방법에 대한 모색

Corelocation의 지원 메소드를 이용하여 요청을 거리 10m으로 지정

기기를 들고 이동할 경우 소수점 차의 위도 경도를 전달받게 됌.

이를 모두 다 저장하는 것이 아닌 최근에 들어왔던 위도 경도와 절댓값 10 차이가 나는 것만 저장
```  

    
### Case3. 아파트 단지네 GPS의 불안정
  
일반 도로에서 이동경로 표기가 잘되지만. 

<u>아파트 단지 내(집안, 엘레베이터 등) 상황에서는 **가만히 있더라도 움직였다고 인식하는 경우**가 많음</u>
```
이동경로와 이동거리가 계산되는 상황으로 이를 줄일 방안이 필요하다 판단 

보완전  백그라운드 상태에서 위치정보 저장
    
핸드폰을 켜놓은채로 산책을 하진 않음 → 그래서 백그라운드 모듈을 추가해 앱이 백그라운드 상태에서도 실행되도록 수정
    
현재까지 테스트한 결과(양이 적긴 하지만) 내 위치 표기가 애니메이션 처럼 이동되는 것 제외하고 좌표 튐이 많이 완화

```

  
###  Case4. 데이터 전송 방식 
정해진  시간마다 배열로 정의되는 위치들의 정보들을 그떄마다 전송할건지?

나중에 다른 사람에게 공유한다고 했을때 서버에 한번에 보내는게 좋을거 같음

그걸 실시간으로 위치 경도 정보를 초단위나 분단위로 계속 서버나 이런곳에 보내려면 

네트워크 유지가 계속 되어야하는데 이러면 베터리소모/ 최적화의 어려움등이 있음 

추천) 
→  UserDefault, CoreData, SwiftData 중에 산책기록을 저장하는 방식 논의

### Case5. 산책로를 선으로 잇는 방법 모색
경로를 그릴 시 위도 경도 값을 polyline으로 이어 그리게 되었는데,  

 확대시 자연스러운 선보다 각이 지는 경로가 되어 좀 더 자연스럽게 선을 이을 수 있는 방법을 고민 중   

MKdirection 방법으로 해결해나갈 예정
자료는 두 위치간의 경로를 계산하는 예시.  
 * 비동기적으로 실행되며, 경로 계산이 완료되면 클로저가 호출되는데,  
이 클로저 내에서는 경로의 총 거리, 예상 이동 시간, 그리고 경로를 나타내는 polyline을 출력
```swift
import MapKit

let sourceCoordinates = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) 
let destinationCoordinates = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437) 

let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates)
let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates)

let sourceItem = MKMapItem(placemark: sourcePlacemark)
let destinationItem = MKMapItem(placemark: destinationPlacemark)

let directionRequest = MKDirections.Request()
directionRequest.source = sourceItem
directionRequest.destination = destinationItem
directionRequest.transportType = .automobile // or .walking, .transit

let directions = MKDirections(request: directionRequest)
directions.calculate { (response, error) in
    guard let response = response else {
        if let error = error {
            print("Error: \(error)")
        }
        return
    }
    
    let route = response.routes[0]
    print(route.distance) 
    print(route.expectedTravelTime) 
    print(route.polyline) 
}
```

  
### Case6. 주소가 뜨지 않는 문제
위도 경도 위치 정보를 주소 값으로 변환하여 뷰에 띄우려는 작업 

<u>변환은 되지만 **마커 클릭시 주소가 뜨지 않는** 문제</u>로 
 
데이터 구조를 바꿔 비동기로 처리될 수 있도록 해결중
reverseGeocodeLocation 메소드를 사용하여 주소 정보를 가져오는 식으로 방안모색중  
아니면 MKMapViewDelegate의 mapView() 매소드를 구현, 마커뷰를 커스텀설정할지 논의중

```swift
import MapKit

let geocoder = CLGeocoder()
let location = CLLocation(latitude: latitude, longitude: longitude) 

geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
    if let error = error {
        print("Geocoding error: \(error)")
        return
    }
    
    if let placemark = placemarks?.first {
        let marker = MKPointAnnotation()
        marker.title = placemark.name
        marker.subtitle = placemark.locality
        marker.coordinate = location.coordinate
        mapView.addAnnotation(marker)
    }
}
```

  
## 향후 발전 계획
- 각 뷰에 대해서 각자 맡은 부분만 진행하다보니 통합하는 시간이 부족, 통합후 테스트 배포 준비할예정
- Mapkit에 대한 높은 이해도를 바탕으로 정확도 높은 기록앱을 만들 것임
- Firebase기반으로 하는 서버를 구축해서 커뮤니티 기능을 제공할 예정
- 산책로에 따른 음료나 간식 구매 지도, 근처 편의점 찾기 기능 추가 예정
- 산책로 공유를 통한 친구와의 랭킹 시스템 구현 예정
- 산책로에 따른 예상 시간, 거리 표시 기능을 추가하여 더 편리한 이용자 경험을 제공할 예정



