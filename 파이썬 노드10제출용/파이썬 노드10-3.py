menu = ['라떼','아메리카노','모카','녹차','초코라떼','아이스티']
price = [2500,2000,3000,2500,3500,3000]


class Kiosk:
    def __init__(self):
        self.menu = menu
        self.price = price
        self.menu_total = []
        self.menu_price_total = []
        self.menu_price_sum = 0

    # 메뉴 출력 메서드
    def menu_print(self):
        for i in range(len(self.menu)):
            print(i+1,self.menu[i],':',self.price[i],'원')

    #주문 메서드
    def menu_select(self):
        n = int(input('메뉴를 번호를 적어주세요:')) # ex 1기입
        self.menu_price_sum += self.price[n-1]
        self.menu_total.append(self.menu[n-1])
        self.menu_price_total.append(self.price[n-1])
        print(self.menu[n-1],':',self.price[n-1],'원')


    # # 지불
    def pay(self):
        print (f'총 합계 금액은 {self.menu_price_sum}입니다')
        self.pay_methood = 0
        while self.pay_methood != 1 and self.pay_methood != 2:
            self.pay_methood = int(input('현금은 1번 카드는 2번을 눌러주세요:'))
            if self.pay_methood ==1:
                print('직원을 호출하겠습니다.')
            elif self.pay_methood ==2:
                print ('IC칩 방향에 맞게 카드를 꽂아주세요')
            else:
                print('다시 결제를 시도해 주세요.')
    # # 주문서 출력 
    def table(self):
        # 외곽
        print('⟝' + '-' * 30 + '⟞')
        for i in range(5):
            print('|' + ' ' * 31 + '|')

        # 주문 상품명 : 해당 금액
        for i in range(len(self.menu_total)):
            print('|',self.menu_total[i-1],':',self.menu_price_total[i-1],'원')

        print(f'|합계 금액 :,{self.menu_price_sum}' )

        # 외곽
        for i in range(5):
            print('|' + ' ' * 31+ '|')
        print('⟝' + '-' * 30 + '⟞')

a = Kiosk()  # 객체 생성 
a.menu_print()  # 메뉴 출력
a.menu_select()  # 주문
a.pay()  # 지불
a.table()  # 주문표 출력


"""
#회고
22,23줄에서 토탈 리스트에 요소를 추가하는 과정에서 어펜드가아닌
엉뚱하게 self.menu_total += self.menu[n-1] 이런식으로 출력값을
제대로 못내고 있었음 막힌다 싶으면 하는 방법이 맞는지 다시생각해보기
"""
