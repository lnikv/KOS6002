import random

import matplotlib.pyplot as plt

# 숫자 15개 랜덤 생성
numbers = [random.randint(1, 100) for _ in range(15)]

# 그래프 그리기
plt.plot(numbers, marker='o')
plt.title('랜덤 숫자 15개 그래프')
plt.xlabel('인덱스')
plt.ylabel('값')
plt.grid(True)
plt.show()