#1. 프로젝트 1번에서 평행사변형, 사다리꼴 넓이를 구하는 메서드를 직접 작성할 수 있다.
# 사각형 넓이를 구하는 클래스 완성!
class Square:
    def __init__(self):
        self.square = int(input('넓이를 구하고 싶은 사각형의 숫자를 써주세요.\n 1.직사각형 2.평행사변형 3.사다리꼴 \n >>>'))

        if self.square == 1:
            print('직사각형 함수는 rect()입니다.')

        elif self.square == 2:
            print('평행사변형 함수는 par()입니다.')
        
        elif self.square == 3:
            print('사다리꼴 함수는 trape()입니다.')
        
        else:
            print('1, 2, 3 중에서 다시 입력해주세요')

    def rect(self):
        width, vertical = map(int, input('가로, 세로를 입력하세요. 예시 : 가로,세로\n >>>').split(','))
        area = width * vertical
        result = '직사각형의 넓이는 : ' + str(area)
        return result

    def par(self):
        bottom,height = map(int,input('밑변,높이를 입력하세요.:').split(","))
        area = bottom * height
        result = '마름모꼴의 넓이는:' + str(area)
        return result

    def trape(self):
        bottom,top,height = map(int,input('밑변,윗변,높이를 입력하세요:').split(","))
        area = (bottom + top) * height / 2 
        result = '사다리꼴의 넓이는:' + str(area)
        return result

a = Square()  # 객체 생성 & 2, 3을 각각 입력해 봅시다.

