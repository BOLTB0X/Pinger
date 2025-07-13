# Pinger

![초수위화](https://3.gall-gif.com/tdgall/files/attach/images/82/310/776/057/a1fdf49a195cd1851c2472dedf2f0a6c.gif)

## 기술스택

| 구성 요소       | 기술 스택                                | 설명                                      |
|----------------|------------------------------------------|-------------------------------------------|
| Client (App)   | Flutter                                  | 사용자 UI 및 앱 동작                      |
| Server   | Python + Flask (로컬 서버)               | 이미지 저장, 메타데이터 저장, API 제공    |
| AI 모델 서버   | Google Colab + Hugging Face              | 스케치 기반 이미지 생성 (`ControlNet`)     |
| DB             | Firebase Firestore                       | 이미지 메타데이터 관리                    |
| 이미지 저장소  | 로컬 디렉토리 (`/images`), Google Drive | 생성 이미지 저장소                        |

---

## Drawing

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EB%8B%88%EC%B2%B4%20%EB%93%9C%EB%A1%9C%EC%9E%89.gif?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EC%96%B8%EB%8D%94%EB%8D%94%EB%B6%80%EC%B2%98-%EB%93%9C%EB%A1%9C%EC%9E%89.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EC%9D%BC%EB%B0%98-draw.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        ex 그리기 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        ex 그리기 2
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        ex 그리기 3
      </p>
      </td>
    </tr>
  </table>
</p>

---

## Edit

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EA%B7%B8%EB%A6%BC%20%ED%9B%84%20%ED%85%8D%EC%8A%A4%ED%8A%B8%ED%95%84%EB%93%9C%20%ED%99%95%EC%9D%B8.gif?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://raw.githubusercontent.com/BOLTB0X/Pinger/refs/heads/main/Img/%ED%8E%AD%EA%B7%84%20-%201.gif" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%ED%8E%9C-%EA%B5%B5%EA%B8%B0-%EC%A1%B0%EC%A0%95.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        프롬프트 입력 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        프롬프트 입력 2
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        펜 굵기
      </p>
      </td>
    </tr>
  </table>
</p>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/undo.gif?raw=true" 
             alt="image 1" 
             style="width:180px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/redo.gif?raw=true" 
             alt="image 2" 
             style="width:180px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EC%A7%80%EC%9A%B0%EA%B0%9C.gif?raw=true" 
             alt="image 2" 
             style="width:180px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EC%A0%84%EC%B2%B4%EC%82%AD%EC%A0%9C.gif?raw=true" 
             alt="image 2" 
             style="width:180px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        ⬅
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        ➡
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        지우개
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        전체삭제
      </p>
      </td>
    </tr>
  </table>
</p>

## Generate

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EB%8B%88%EC%B2%B4%20%EB%B3%80%ED%99%98%20%EB%B0%8F%20%EC%A0%80%EC%9E%A5.gif?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EC%96%B8%EB%8D%94%EB%8D%94%EB%B6%80%EC%B2%98-%EA%B2%B0%EA%B3%BC%20%EB%B0%8F%20%EC%A0%80%EC%9E%A5.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EB%A6%AC%EC%8A%A4%ED%8A%B8%EB%B7%B0.jpg?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        결과 반환 및 저장 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        결과 반환 및 저장 2
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        list
      </p>
      </td>
    </tr>
  </table>
</p>

## 참고

- [Hugging face](https://huggingface.co/)

    - [control_v11p_sd15_lineart](https://huggingface.co/lllyasviel/control_v11p_sd15_lineart)

    - [Stable Diffusion v1-5 ](https://huggingface.co/lllyasviel/sd-controlnet-scribble)

    - [ControlNet](https://huggingface.co/lllyasviel/ControlNet?source=post_page-----5f67979ea9a---------------------------------------)

    - [Interrogator](https://huggingface.co/spaces/pharmapsychotic/CLIP-Interrogator)

    - [AutoPipelineForImage2Image](https://huggingface.co/docs/diffusers/main/using-diffusers/img2img)

- [블로그 참조 - Hugging Face 회원가입, 토큰 발급, APIKEY 발급 방법, 개발 환경 설정](https://hunseop2772.tistory.com/372)

- [flutter dev - RenderRepaintBoundary](https://api.flutter.dev/flutter/rendering/RenderRepaintBoundary-class.html)

- [flutter dev - toImage](https://api.flutter.dev/flutter/rendering/RenderRepaintBoundary/toImage.html)

- [블로그 참고 - 뇌님 참고(HandshakeException: Handshake error in client (OS Error: CERTIFICATE_VERIFY_FAILED))](https://brain-nim.tistory.com/138)

- [Stackoverflow - Flutter HTTPS Handshake error in client (OS Error: CERTIFICATE_VERIFY_FAILED: ok(handshake.cc:363))](https://stackoverflow.com/questions/54928080/flutter-https-handshake-error-in-client-os-error-certificate-verify-failed-ok)

- [블로그 참고 - .env 파일 적용](https://velog.io/@marksen/Flutter-.env-%ED%8C%8C%EC%9D%BC-%EC%A0%81%EC%9A%A9)

- [블로그 참조 - tkayyoo(위젯으로 이미지 찍어내기)](https://tkayyoo.tistory.com/85)

- [블로그 참조 - Studying ITs(리눅스에서 파이썬 개발환경 구축)](https://authentic-information.tistory.com/35)

- [블로그 참조 - 고은별의 기술 공유 연구소(Flutter - 내가 만든 앱, 내 휴대폰으로 디버깅 하기)](https://luvris2.tistory.com/715#google_vignette)

- [블로그 참조 - 까사파파(FloatingActionButton 여러개 사용시 에러및 오류 해결 하는 법)](https://casapapa.tistory.com/40)

- [블로그 참조 - 영로그(클린 아키텍처 쉽게 이해하기)](https://heui-yong.github.io/flutter/post-flutter-clean-architecture/)

- [Flutter pub - painter](https://pub.dev/packages/painter)

- [블로그 참고 - 마느아의 전산 공부 블로그(AppBar 총정리(flutter))](https://learncom1234.tistory.com/17)

- [오픈 소스 - 플라스크 REST API 튜토리얼](https://colab.research.google.com/github/PyTorchKorea/tutorials-kr/blob/master/docs/_downloads/786469bd4d28fe2528b92a6d12fb189e/flask_rest_api_tutorial.ipynb)

- [블로그 참고 - dev-nam(키보드가 열렸는지 닫혔는지 확인하는 방법)](https://dev-nam.tistory.com/30)

- [블로그 참고 - 참깨빵위에참깨빵_(BottomSheet 사용법)](https://onlyfor-me-blog.tistory.com/1088)

- [Medium - Flutter Community(Build a Custom Bottom Navigation Bar in Flutter with Animated Icons from Rive)](https://medium.com/flutter-community/build-a-custom-bottom-navigation-bar-in-flutter-with-animated-icons-from-rive-13651bc80629)

- [블로그 참고 - day0404(Flutter Animation 만들기 (with Provider))](https://day0404.tistory.com/51)

- []()