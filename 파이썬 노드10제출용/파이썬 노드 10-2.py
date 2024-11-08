menu = ['americano', 'latte', 'mocha', 'yuza_tea', 'green_tea', 'choco_latte']
price = [2000, 3000, 3000, 2500, 2500, 3000]

class Kiosk:
    
    def __init__(self):
        # 문제 2-1의 답을 입력하세요. 
        self.menu = menu
        self.price = price
        self.order_menu = []  # 주문 리스트
        self.order_price = []  # 가격 리스트
        self.price_sum = 0

    # 메뉴 출력 메서드
    def menu_print(self):
        for i in range(len(self.menu)):
            print(i + 1, self.menu[i], ' : ', self.price[i], '원')

    # 주문 메서드
    def menu_select(self):
        print()  # 줄 바꿈
        n = 0
        while n < 1 or len(menu) < n:
            n = int(input("음료 번호를 입력하세요 : "))  # 음료 번호 입력

            # 메뉴판에 있는 음료 번호일때
            if 1 <= n and n <= len(menu):
                self.price_sum += self.price[n-1]  # 선택 음료의 가격
                self.order_menu.append(self.menu[n-1])
                self.order_price.append(self.price[n-1])
            # 메뉴판에 없는 번호일 때
            else:  
                print("없는 메뉴입니다. 다시 주문해 주세요.")

        t = 0  # 기본값을 넣어주고
        while t != 1 and t != 2:  # 1이나 2를 입력할 때까지 물어보기
            t= int(input("HOT 음료는 1을, ICE 음료는 2를 입력하세요 : "))
            # 문제 2-3. 음료의 온도에 따라 temp 변수를 "HOT" 또는 "ICE"로 지정하세요.   
            # 힌트: if문을 활용해보세요.        
            if t == 1:
                self.temp = 'HOT'
            elif t == 2:
                self.temp = 'ICE'
            else:    
                print("1과 2 중 하나를 입력하세요.\n")
        # 문제 2-2의 답을 입력하세요.
        print('주문 음료', self.temp, self.menu[n-1] ,' : ', self.price[n-1], '원')  # 온도 속성을 추가한 주문 결과 출력
        
        
        while n != 0:  # 지불을 선택하기 전까지 반복합니다.
            n = int(input("추가 주문은 음료 번호를, 지불은 0을 누르세요 : "))  # 추가 주문 또는 지불
            if n > 0 and n < len(self.menu) + 1: 
                self.price_sum += self.price[n-1]
                self.order_menu.append(self.menu[n-1])
                self.order_price.append(self.price[n-1])
            # 추가 음료 온도 
                t = 0  # 기본값을 넣어주고
                while t != 1 and t != 2:  # 1이나 2를 입력할 때까지 물어보기

                    t= int(input("HOT 음료는 1을, ICE 음료는 2를 입력하세요 : "))
                    # 문제 2-3. 음료의 온도에 따라 temp 변수를 "HOT" 또는 "ICE"로 지정하세요.   
                    # 힌트: if문을 활용해보세요.        
                    if t == 1:
                        self.temp = 'HOT'
                    elif t == 2:
                        self.temp = 'ICE'
                    else:    
                        print("1과 2 중 하나를 입력하세요.\n")
                    print('주문음료',self.temp,self.menu[n-1],':',self.price[n-1],'원', '\n합계:',self.price_sum,'원' )   
            # 문제 2-4. 추가 음료의 온도를 입력받고, 가격 리스트, 주문 리스트, 합계 금액을 업데이트해보세요.
            elif n != 0 or n > len(self.menu) + 1: 
                print("없는 메뉴입니다. 다시 주문해 주세요.")
            else : 
                n == 0 # 지불을 입력하면
                print("주문이 완료되었습니다.")
                #print(self.order_menu,self.order_price)
                print(list(zip(self.order_menu,self.order_price)),"\n",'총 가격: ',sum(self.order_price)) # 확인을 위한 리스트를 출력합니다. 



modu = Kiosk()
modu.menu_print()
modu.menu_select()


#순서가 2번문제에서 3번으로 간거보단 3번에서 2번으로 넘어와서 풀어가지고 섞인게 있습니다.
