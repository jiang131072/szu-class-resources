#import "@preview/ilm:1.4.0": *

#set text(
  font: ("Noto Serif", "Noto Serif SC", "Noto Color Emoji"),
  lang: "zh",
  region: "CN",
)

#show: ilm.with(
  title: [SZU NA复习笔记],
  author: "Keaton Jiang",
  date: datetime(year: 2025, month: 1, day: 4),
  chapter-pagebreak: false,
)

#set math.mat(delim: "[")
#let btt(..items) = {
  align(center + horizon)[
    #table(
      stroke: none,
      table.vline(x: 1),
      table.hline(y: 1),
      ..items
    )
  ]
}


= 基础

- 先加小数，由小到大逐次相加
- 避免两个相近数相减
- 避免小数作除数和大数作乘法

非数值方法：
- 开方、超越函数、极限、微分、积分
- 超越函数: 三角函数、对数函数、反三角函、指数函数

一些约定：
- $bold(L) bold(U)$ 分表别是下、上三角矩阵
- $a_(i j)$ 表示$i$行$j$列的元素。算法中的迭代变量为 $r$，循环变量为 $k$

== 误差和有效数字

根据定义，误差限是不唯一的。

- 绝对误差 $E(X^*)=x^*-x$

实际一般使用上界 $|E(X^*)|<=epsilon(x^*) =>x=x^*plus.minus epsilon$，$epsilon$称为绝对误差限

- 相对误差 $E_r (x)=E/x = (x^*-x)/x$

实际一般使用$E_r^* (x^*)=E/x^*=(x^*-x)/x^*$替代计算

- 有效数字

数值近似的标准形式

$
  x^*=plus.minus 10^m times overline(0.x_1 x_2 x_3...x_n x_(n+1)...x_p)
$

定义使误差限$|e^*|<=1 / 2 times 10^(m-n)$成立的最大整数n为有效数字。

1. $m$是近似的数量级，取整数位数或小数点后0的数量取负
2. $m-n$是误差的数量级，取法相同，但超过一半需要加一
3. 求取$n=m-(m-n)$

四舍五入时，有效数字$n$等于剩下的位数（不包括前导0），误差限定义和一般近似相同。

对于相对误差，
- $n$位有效数字的相对误差限 $E^*_r=1/2 times 10^(1-n)$，即放宽一位
- 误差限 $E^*_r=1/2 times 10^(-n)$，那么至少具有$n$位有效数字

= 解线性方程组

没有特别说明的则索引从1开始，矩阵为原地修改。
$
  cases(
  bold(L) y = b,
  bold(U) x = y
)
$

如果采用增广矩阵，则$bold(U) x = b$

== 高斯和高斯列主元消元法

高斯法即标准手工解法，列主元法带行交换。

== 直接三角分解

给出爱因斯坦标记的一个变形，

$
  v(i,j,k)=sum_(k=r)^k l_(i r)u_(r j)
$

=== Doolittle分解

$
  "for" r=1 "to" n,
  cases(
u_(r j)
&=a_(r j)-sum_(k=1)^(r-1)l_(r k)u_(k j)
&=&a_(r j)&-v(r,j,r-1) &[j>=r],
l_(i r)
&=1/(u_(r r))(a_(i r)-sum_(k=1)^(r-1)l_(i k)u_(k r))
&=1/(u_(r r))(&a_(i r)&-v(i,r,r-1))&[i>r]
)
$

处理顺序：
#align(center + horizon)[#table(
    columns: 4,
    [1], [2], [3], [4],
    [5], [8], [9], [A],
    [6], [B], [D], [E],
    [7], [C], [F], [G],
  )]


=== 部分选主元的Dooolittle分解

1. $a_(i r)-=v(i,r,r-1)$
2. 确定下方列上最大值$|a_(i r)|$，整行交换
3. 分解：
  1. 列：$a_(i r)"/="a_(r r)$
  2. 行：$a_(r j)-=v(r,j,r-1)$
4. $r+=1$

处理顺序（不包括行交换）：
#align(center + horizon)[#table(
    columns: 4,
    [1], [8], [9], [A],
    [2,5], [B], [G], [H],
    [3,6], [C,E], [I], [L],
    [4,7], [D,F], [J,K], [M],
  )]

Doolittle分解一般采用增广形式。

=== 平方根法

平方根法只适用于对称正定矩阵。分解目标：$A=L L^T$

每轮先求出对角元素，
$
  l_(r r)=sqrt(a_(r r)-sum_(k=1)^(r-1)l_(r k)^2)
$

再对下三角整行求和（不包括对角元素）。
$
  l_(i r)=1 / l_(r r)(a_(i r)-sum_(k=1)^(r-1)l_(i k)l_(r k))
$

最终消去：
$
  cases(
  bold(L) y = b,
  bold(L^T) x = y
)
$

=== 追赶法

#let eye = "eye"

追赶法只适用于三对角线的对角占优矩阵。这里只讨论Crout形式。

记原始参数矩阵和对应$L U$融合矩阵分别有
$
  cases(
eye(-1)&:a_(2...n) &| eye(-1)&:alpha_(2...n),
eye(0)&:b_(1...n) &| eye(0)&:beta_(1...n),
eye(1)&:c_(1...n-1) &| eye(1)&:gamma_(1...n-1)
)
$

其中，$alpha,beta$属于$L$，$gamma$属于$U$（对角线填充1）。
则
$
  cases(
alpha_i&=a_i\
beta_i&=b_i-alpha_i gamma_(i-1) \
gamma_i&=c_i/beta_i
)
$

- $beta_i=$【本位$-$左边的/上面的】
- $gamma_i=$【本位/左边的】

处理顺序：
#align(center + horizon)[#table(
    columns: 4,
    [1], [2], [], [],
    [0], [3], [4], [],
    [], [0], [5], [6],
    [], [], [0], [7],
  )]

= 插值法与最小二乘法

以下讨论索引从0开始。

在样本点$x_(0:n)上$定义一个辅助函数：
$
  P_k (m)=product_(i=0,i!=k)^(i=n) (m-x_i)
$

== 拉格朗日插值

$
  cases(
  l_i (x)=(P_i (x))/(P_i (x_i)),
  L_n (x)=sum_(i=0)^n y_i l_i (x)
)
$

=== 误差

插值余项和误差估计：
$
  R_n (x)&=(f^((n+1)) (xi)) / (n+1)! product_(i=0)^(i=n) (x-x_i)\
  |R_n (x)|&<= (max_(a<=x<=b)|f^((n+1))(x)|) / (n+1)! |product_(i=0)^(i=n) (x-x_i)|
$

计算误差需要原始函数，而不是插值函数。

=== 分段插值（二次）

分段二次插值时，选相邻点中距离插值点近的方向选第三个点。

== 牛顿插值

一阶均差：
$
  f[x_i,x_j]=(f(x_i)-f(x_j)) / (x_i-x_j)
$

k阶均差：
$
  f[...,x_(k-2),x_(k-1),x_(k)]=
  (f[...,x_(k-2),x_(k-1)]-f[...,x_(k-2),x_k]) / (x_(k-1)-x_k)
$

正向、反向和余项公式：
$
  N_n (x)&=f(x_0)+sum_(k=1)^n f[x_0,...,x_k] product_(i=0)^(k-1) (x-x_i)\
  N_n (x)&=f(x_n)+sum_(k=1)^n f[x_n,...,x_(n-k)] product_(i=0)^(k-1) (x-x_(n-i))\
  R_n (x)&approx[x_0,...,x_k,x_(k+1)]product_(i=0)^(k) (x-x_i)
$

正向从0开始：
$
  N_n (x)=&+f(x_0)\
  &+f[x_0,x_1](x-x_0)\
  &+f[x_0,x_1,x_2](x-x_0)(x-x_1)\
  &...
$

反向从9开始：
$
  N_n (x)=&+f(x_9)\
  &+f[x_9,x_8](x-x_9)\
  &+f[x_9,x_8,x_7](x-x_9)(x-x_8)\
  &...
$

均差表：
#align(center + horizon)[
  #table(
    columns: 4,
    [$x_k$], [$f(x_k)$], [$f[x_k,x_(k+1)]$], [$f[x_k,x_(k+1),x_(k+2)]$],
    [$x_0$], [$f(x_0)$], [], [],
    [$x_1$], [$f(x_1)$], [$f[x_0,x_1]$], [],
    [$x_2$], [$f(x_2)$], [$f[x_1,x_2]$], [$f[x_0,x_1,x_2]$],
  )]

正向下山，反向隧穿。

=== 等距插值

正向和反向公式：
$
  N_n (x_(0)+t h)&=f(x_0)+sum_(k=1)^n (laplace^k f_0) / (k!)product_(i=0)^(k-1) (t-i)\
  N_n (x_(n)-t h)&=f(x_n)+sum_(k=1)^n (nabla^k f_n) / (k!)product_(i=0)^(k-1) (t+i)\
  |R_n (x)|&<= (max_(a<=x<=b)|f^((n+1))(x)|) / (n+1)! |product_(i=0)^(i=n) (x-x_i)|\
  &=~|product_(i=0)^(i=n) (t plus.minus i)|h^(n+1)
$

其中，$h$为等距间隔,
$
  t=cases(
  (x-x_0)/h&|"forward",
  (x_n-x)/h&|"backward")
$

正向从0开始：
$
  N_n (x_0+t h)=
  &+f_0\
  &+(laplace^1 f_0) / 1! t\
  &+(laplace^2 f_0) / 2! t(t-1)\
  &...
$

反向从9开始：
$
  N_n (x_9-t h)=
  &+f_9\
  &+(nabla^1 f_9) / 1! t\
  &+(nabla^2 f_9) / 2! t(t+1)\
  &...
$

差分表和均差表对比，
- 少第一列，因为间距相等；因此也不作除法
- $laplace^m f_k = nabla^m f_(k+m)$

差分表（紧凑差分表中后向差分更加规整）：
#align(center + horizon)[
  #table(
    columns: 3,
    [$f(x_k)$], [$laplace f_k$], [$laplace^2 f_k$],
    [$f(x_0)$], [], [],
    [$f(x_1)$], [$laplace f_0=nabla f_1$], [],
    [$f(x_2)$], [$laplace f_1=nabla f_2$], [$laplace^2 f_0=nabla^2 f_2$],
  )]

== 最小二乘法

思路：确定一组基函数$phi_k(x)$，最终拟合函数为$f(x)=sum_(k=0)^(n-1) c_k phi_k(x)$，因此需要确定$c_k$。

方法：解法方程组，形如，

$
  mat(
    <phi_0comma phi_0>,   ... , <phi_0comma phi_(n-1)>;
    dots.v,  dots.down, dots.v;
    <phi_(n-1)comma phi_0>,   ... , <phi_(n-1)comma phi_(n-1)>;
  ) mat(
    c_0;
    dots.v;
    c_(n-1);
  )=mat(
    <f comma phi_0>;
    dots.v;
    <f comma phi_(n-1)>;
  )
$

其中，$w_i$为数据权重，默认为1。$f(x_i)=y_i$。满足$<phi_i comma phi_j> =<phi_j comma phi_i>$

$
  <h comma g> = sum_(i=0)^(n-1) w_i h(x_i) g(x_i)
$

= 数值积分和微分

== Newton-Cotes公式

权重表：
#align(center + horizon)[#table(
    columns: 7,
    table.header([$n$], [权重分片], table.cell(colspan: 5, [权重])),
    [1(T)], [2], [1], [1], [], [], [],
    [2(S)], [6], [1], [4], [1], [], [],
    [3], [8], [1], [3], [3], [1], [],
    [4(C)], [90], [7], [32], [12], [32], [7],
  )]

余项：
$
  h&: "Step size"\
  R(T)&=-1/12 h^3 f^((2))(xi)\
  R(h)&=-1/90 h^5 f^((4))(xi)\
  R(C)&=-8/945 h^7 f^((6))(xi)
$

== 复合求积法

即将一个区间分成多个小区间，然后对每个小区间求低次积分。权重可以通过标准公式的overlap来计算。

- 变步长方法

分段数不断翻倍，直到满足误差控制条件：
$
  |(Y_(2n)-Y_n)|<=epsilon times cases(
  4^1-1 "for" T,
  4^2-1 "for" S,
  4^3-1 "for" C
  )
$

== 数值微分

- 两点公式
$
  cases(
  f'(x_0)=1/h (y_1-y_0)-h/2 f''(xi),
  f'(x_1)=1/h (y_1-y_0)+h/2 f''(xi)
  )
$

- 三点公式
$
  cases(
  f'(x_0)=1/(2h) (-3y_0+4y_1-y_2)+h^2/3 f'''(xi),
  f'(x_1)=1/(2h) (-y_0+y_2)-h^2/6 f'''(xi),
  f'(x_2)=1/(2h) (y_0-4y_1+3y_2)+h^2/3 f'''(xi)
  )
$
矩阵形式：
$
  1 / (2h) mat(
    -3, 4, -1;
    -1, 0, 1;
    1, -4, 3
  ) mat(
    y_0;
    y_1;
    y_2
  )+f'''(xi)h^2 mat(
    1/3;
    -1/6;
    1/3
  )
  =mat(
    f'(x_0);
    f'(x_1);
    f'(x_2)
  )
$

= 常微分方程

== 欧拉法

- 后退：$y_(i+1)=y_i+h f(x_(i+1),y_(i+1))$（隐式）
- 梯形法：$y_(i+1)=y_i+h/2 (f(x_i,y_i)+f(x_(i+1),y_(i+1)))$（隐式）
- 预测校正
#btt(
  columns: 3,
  table.header([1],[0],[1]),
  [0],[],[],
  [1],[1],[],
)

== RK法
- 1 前进欧拉
#btt(
  columns: 2,
  table.header([1],[1]),
  [0],[],
)

- 2 改进欧拉
#btt(
  columns: 3,
  table.header([2],[1],[1]),
  [0],[],[],
  [1],[1],[],
)

- 2 Heun / Ralston
#btt(
  columns: 3,
  table.header([4],[1],[3]),
  [0],[],[],
  [2/3],[2/3],[],
)

- 3
#btt(
  columns: 4,
  table.header([6],[1],[4],[1]),
  [0],[],[],[],
  [1/2],[1/2],[],[],
  [1],[-1],[2],[],
)

- 4
#btt(
  columns: 5,
  table.header([6],[1],[2],[2],[1]),
  [0],[],[],[],[],
  [1/2],[1/2],[],[],[],
  [1/2],[0],[1/2],[],[],
  [1],[0],[0],[1],[],
)

= 逐次逼近法

== 范数

$
  cases(
||A||_infinity&=max_(1<=i<=n) sum_(j=1)^n|a_(i j)|,
||A||_1&=max_(1<=j<=n) sum_(i=1)^n|a_(i j)|,
||A||_2&=sqrt(rho(A^T A))=sqrt(max(|lambda_i|)) "for" A^T A,
||A||_F&=sqrt(sum |a_(i j)|^2)
)
$

求特征值：
$
  det(A-lambda I)=0
$


== 解线性方程组

=== Jacobi法
形如
$
  mat(
    a_(0 0), a_(0 1), a_(0 2);
    a_(1 0), a_(1 1), a_(1 2);
    a_(2 0), a_(2 1), a_(2 2)
  )mat(
    x_0;
    x_1;
    x_2
  )=mat(
    b_0;
    b_1;
    b_2
  )
$

则迭代公式为
$
  mat(
    x_0;
    x_1;
    x_2
  )^((n+1))=mat(
    1/a_(0 0),0,0;
    0,1/a_(1 1),0;
    0,0,1/a_(2 2);
  )underbrace(mat(
    0,-a_(0 1),-a_(0 2);
    -a_(1 0),0,-a_(1 2);
    -a_(2 0),-a_(2 1),0;
  ), "H")mat(
    x_0;
    x_1;
    x_2
  )^n+underbrace(mat(
    b_0/a_(0 0);
    b_1/a_(1 1);
    b_2/a_(2 2)
  ), "G")
$

=== Gauss-Seidel法

Gauss-Seidel法使用Jacobi法中的H、G成分，按$i=0:n-1$顺序不断更新

$bold(x)_"latest"$指当前算出最新的值，而不以迭代次数作区分。

$
  x_i^((n+1))=H[i]bold(x)_"latest"+G[i]
$

== 解非线性方程

迭代法：将方程转化为$x=f(x)$的形式，然后迭代。

=== 牛顿法

$
  x_(n+1)=x_(n)-f(x_n) / (f'(x_n))
$

=== 弦截法

$
  x_(n+1)=x_n-f(x_n) (x_n-x_(n-1))/(f(x_n)-f(x_(n-1)))
$

本质上是用两点的斜率代替导数。需要两个初始值。

=== 二分法

利用罗尔定理，迭代划分区间直到确认所有单根区间（因此需要根的数量已知）。然后用二分逼近即可。