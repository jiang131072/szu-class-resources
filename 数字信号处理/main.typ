#import "@preview/ilm:1.4.0": *

#set text(
  font: ("Noto Serif", "Noto Serif SC", "Noto Color Emoji"),
  lang: "zh",
  region: "CN",
)

#show: ilm.with(
  title: [SZU DSP复习笔记],
  author: "Keaton Jiang",
  date: datetime(year: 2024, month: 12, day: 31),
  chapter-pagebreak: false,
)

= 基础

等比数列求和：
$
  sum_(i=0)^n a_i = (a_0-a_(n+1)) / (1-q)
$

几何级数求和（$|q|<1$）：
$
  sum_(i=0)^infinity a_i = a_0 / (1-q)
$

指数级数求和：
$
  sum_(i=0)^infinity x^i / (i!) = e^x
$

欧拉公式：
$
  e^(j theta) &= cos theta + j sin theta\
  cos theta &= 1 / 2 (e^(j theta) + e^(-j theta))\
  sin theta &= 1 / (2j) (e^(j theta) - e^(-j theta))
$

- 单位斜坡序列：$r(n)= n u(n)$
- 矩形序列：$R_N (n)= u(n) - u(n-N)$
- 前向差分: $laplace x(n)=x(n+1)-x(n)=nabla x(n+1)$
- 后向差分: $nabla x(n)=x(n)-x(n-1)=laplace x(n-1)$

== 数模转换和周期性

$ omega = 2pi f / f_s $

其中$f_s$为采样频率，$f$为信号频率，$omega$为数字角频率。

奈奎斯特定律依然适用：采样频率要大于信号（最高频率成分）频率的两倍。

采样信号：
$
  hat(x)(t) = sum_(n=-infinity)^infinity x(n T) delta(t-n T)
$

对正弦信号采样时，采样频率要大于信号频率的两倍？

周期性：
- 数模转换：$T=f_s/f in QQ$，$T$为数字周期，$f_0$为信号周期
- 三角函数：$T=2pi/omega in QQ$
- 数模转换时，周期性和频谱泄漏是无关的

== 能量和功率

$
  E &= sum_(n=-infinity)^infinity |x(n)|^2\
  P &= lim_(N->infinity)1 / (2N+1)sum_(n=-N)^N|x(n)|^2
$

- 若能量有限，功率必定为0，称为能量信号；
- 若功率非0且有限，称为功率信号。

== 信号的对称性

共轭对称的下标借用了奇偶性的概念。

#table(
  columns: 2,
  align: center + horizon,
  table.header[种类][公式特征],
  [实序列], [$x(n)=x^* (n)$],
  [虚序列], [$x(n)=-x^* (n)$],
  [偶序列], [$x_e (n)=x_e (-n)$],
  [奇序列], [$x_o (n)=-x_o (-n)$],
  [共轭对称（实偶虚奇）], [$x_e (n)=x_e^* (-n)$],
  [共轭反对称（实奇虚偶）], [$x_o (n)=-x_o^* (-n)$],
)


== 卷积的计算

$
  y(n)&=x(n)*h(n)\
  &=sum_(m=-infinity)^infinity x(m) h(n-m)\
  &=sum_(m=-infinity)^infinity x(n-m) h(m)
$

从$m$的角度看，把$h(m)$看作常数，则卷积就是以$h(m)$为权重，对序列$x(m)$进行移动求和。每次迭代中，确定权重$h(m)$，并将$x(n)$移动$m$个单位，

从$n$的角度看，确定一个$n$，则确定了对应输出序列中一个元素的表达式，此时$(n-m)+(m)equiv n$，一个常数，即在$n$两侧对称的取值相乘，最后求和。（每次移动半位）

常数序列加权可以用来理解因果性的充要条件是$h(n)=0, n<0$。比如带入$m=1$，那么对应的$h(n-1)$在$n<1$时必须为0，否则输出的$n<1$的值就依赖于$x(1)$。


离散卷积结果的长度：$N_1+N_2-1$

圆周卷积可先计算正常卷积，再按点数进行截断，余部按位加到头部位。

相关：

$ r_(x y)(n)=sum_(m=-infinity)^infinity x(n) y(n-m)=x(n)*y(-n) $

注意$y(-n)$是$y(n)$的翻转（偶对称序列）。将其翻转后，可按卷积计算。建议采用序列位移法，因为翻转会导致数值分布在正负半轴两侧，按位计算量会变大。

相关是偶对称的。即$r_(x y)(n)=r_(y x)(-n)$。易证：$y(-n)=x(-n)*h(-n)$

== 系统性质的判定

系统的是序列的映射，需要以整个序列的视角来看待映射关系。我们可以给出一个更清晰的notation：

$
  T: x(n) -> y(n)
$

那么，比如$y(n)=n x(n)$在这种notation下，可以记为

$
  T: x(n) -> n x(n)
$

不难发现，由于n实际上代表了具体的序列元素位置，所以其中的$n$实际上是是一个斜坡序列$r(n)$，而不是一个常数。因此，更完整的notation应该是：

$
  T: x(n) -> r(n) x(n)
$

由于系统研究序列和序列之间的关系，同样需要理解，$r(n)$是一个常序列，对应常数概念（常数在这里依然存在）如果研究其移不变性，给出的notation应当是：

$
  T: x(n-n_0) -> bold(r) dot x(n-n_0)
$

$bold(r)$和序列变量$n$无关，因此我们不应当混淆它。再如，

$
  T: x(n) -> x(n^2)
$
这个变换实际上是一种抽样，特别之处在于它的间隔是非均匀的。并且在上面这个例子中，它是一个非因果变换，重采样操作把正时间轴上的信号映射到了负时间轴上。

移动是对序列的一个操作，而不是对具体值的操作，所以如$x(n^2)$的移动结果是$x(n^2-n_0)$。

因果性（causality)：$h(n)=0, n<0$，本质上是“系统的输出只依赖于当前和过去的输入”，具体表现为“系统输出为0直到有非0输入出现”，也即初始松弛。

稳定性（stability, BIBO）：$sum_(n=-infinity)^infinity |h(n)|<infinity$，有界输入必定有界输出。

只有LSI系统才会有冲激响应函数$h$，若不满足这两个条件，其无法表征这个系统。

- 一个差分方程不能唯一地确定一个系统（边界条件）
- 差分方程形式上不保证任何性质

= z变换

z域本质上是一个极坐标系。

$
  x(n)->X(z)=sum_(n=-infinity)^infinity x(n)z^(-n)
$

收敛的条件是级数绝对可和，即$sum_(n=-infinity)^infinity |x(n)z^(-n)|<infinity$。

== 常用变换对及其收敛域

$
  a^n u(n) &-> 1 / (1-a z^(-1))&, |z|>|a|\
  a^n u(-n-1) &-> - ~&, |z|<|a|\
  n a^n u(n) &-> (a z^(-1)) / (1-a z^(-1))^2&, |z|>|a|\
  n a^n u(-n-1) &-> - ~&, |z|<|a|\
$

== 常用性质

- 若收敛域包含无穷远处，则系统是因果的。
- 若收敛域包含单位圆，则系统是稳定的。

基本性质：时移、线性、卷积

1. z域复尺度变换
$
  a^n x(n) &-> X(z / a)\
$

2. z域微分
$
  n x(n) &-> -z (dif X(z)) / (dif z)
$

3. 时域反转
$
  x(-n) &-> X(z^(-1))
$

4. 共轭\*
$
  x^*(n) &-> X^*(z^*)
$

5. 初值和终值定理\*
$
  x(0) &= X(infinity)\
  x(infinity) &= lim_(z->1) [(z-1)X(z)]
$

要求为因果序列；对于终值定理，要求稳定或者至多在$z=1$处有一阶极点。

= DtFT

$
  X(e^(j omega))=sum_(n=-infinity)^infinity x(n)e^(-j omega n)
$

$
  x(n)=1 / (2pi) integral_(-pi)^(pi) X(e^(j omega)) e^(j omega n) dif omega
$

显然是z变换中$r=1$的特例。存在性：绝对可和是充分条件，但不必要

== 常用变换对

$
  delta(n-n_0) &-> ~\
  a^n u(n), |a|<1 &-> ~\
  e^(j omega_0 n) &-> 2pi delta((omega-omega_0))_(2pi)\
  u(n) &-> 1 / (1-e^(-j omega)) + pi delta((omega))_(2pi)\
  sin(omega_0 n) / n &-> cases(pi space |omega|<omega_0, 0 space omega_0<|omega|<=pi)\
$

== 常用性质

$
  a^n x(n) &-> ~\
  x(-n) &->~\
  x^*(n) &-> X(e^(-j omega))\
  n x(n) &-> j (dif X(e^(j omega))) / (dif omega) \
$

帕塞瓦尔定理：
$
  sum_(n=-infinity)^infinity |x(n)|^2 =
  1 / (2pi) integral_(-pi)^(pi) |X(e^(j omega))|^2 dif omega
$

== 对称性质

- 实序列：$x (n)=x^* (n)$
- 虚序列：$x (n)=-x^* (n)$
- 共轭对称：$x_e (n)=x_e^* (-n)$，实偶虚奇
  - 偶序列：$x (n)=x (-n)$
- 共轭反对称：$x_o (n)=-x_o^* (-n)$，实奇虚偶
  - 奇序列：$x (n)=-x (-n)$

共轭对称性占用了奇偶的的下标，因为复域上讨论整体奇偶没有意义。任意序列可以分解成一个共轭对称序列和一个共轭反对称序列：（实域上退化为奇偶）
$
  x_e (n)=1 / 2 (x(n)+x^* (n))\
  x_o (n)=1 / 2 (x(n)-x^* (n))
$

时频域上的对应关系如下（实对偶，虚对奇）：
- $Re[x(n)] -> X_e (e^(j omega))$
- $j Im[x(n)] -> X_o (e^(j omega))$
- $x_e (n) -> Re[X(e^(j omega))]$
- $x_o (n) -> j Im[X(e^(j omega))]$

= DFS / DFT

$
  x(n) &-> X(k)=sum_(n=0)^(N-1) x(n) W_N^(n k)\
  X(k) &-> x(n)=1 / N sum_(k=0)^(N-1) X(k) W_N^(-n k)
$

其中，$W_N=e^(-j (2 pi) / N)$，$N$为序列长度，$k in 0:N-1$。显然是DtFT上的一个等距离散采样。本质是将有限长序列看作一个周期，对其延拓，然后做DFS。

频谱混叠和泄漏

== 常用性质

循环移位和调制：
$
  x((n-n_0))_N &-> W_N^(n_0 k) X(k)\
  X((k-k_0))_N &-> W_N^(-n k_0)x(n)
$

帕塞瓦尔定理：
$
  sum_(n=0)^(N-1) |x(n)|^2 = 1 / N sum_(k=0)^(N-1) |X(k)|^2
$

== 对称性质

- 实序列的DFT是共轭对称的，即实部偶对称，虚部奇对称
- 虚序列的DFT是共轭反对称的，即实部奇对称，虚部偶对称

共轭对称性：
- $Re[x(n)] -> X_(e p) (k)$
- $j Im[x(n)] -> X_(o p) (k)$
- $x_(e p) (n) -> Re[X(k)]$
- $x_(o p) (n) -> j Im[X(k)]$

分解：
$
  x_(e p) (n)=1 / 2 (x(n)+x^* (N-n))\
  x_(o p) (n)=1 / 2 (x(n)-x^* (N-n))
$

== 采样

频谱分辨率和记录时间是倒数关系 $T_0 = 1 / f_0$

频谱分辨率等于采样频率除以采样点数 $f_s / N$

记录时间等于采样点数除以采样频率 $N / f_s$

== Radix-2 FFT

计算量：
- 蝶形算符数$n = N log_2 N$
- 乘法数量$2n | N^2$
- 加法数量$n | N^2-N$

蝶形算符：
#align(center + horizon)[#image("bfops.png", width: 40%)]

时间抽取流图（浅层权重是深层的采样）：
#align(center + horizon)[#image("fft.png", width: 60%)]

$"IFFT"[X(k)] = 1 / N "FFT"^*[X^*(k)]$

= 滤波器

IIR和FIR的比较：
#table(
  align: center + horizon,
  columns: 3,
  table.header[特征][I(nfinite)IR滤波器][F(inite)IR滤波器],
  [单位冲激响应], [无限长], [有限长，所以稳定],
  [结构], [递归结构], [非递归结构],
  [极点], [自由], [原点],
  [滤波器阶数], [低], [高],
  [线性相位], [否], [可以],
  [FFT加速], [否], [可以],
  [设计方法], [可用模拟滤波器], [借助计算机],
  [用途], [高效率], [高性能],
)

转置定理：输入输出位置交换，且支路方向交互，则网络性质不变。

== IIR

=== 直接I型和直接II型（典范型）

$
  H(z)=(sum_(k=0)^M b_k z^(-k)) / (1- sum_(k=1)^N a_k z^(-k))
$

$
  y(n)=sum_(k=1)^N a_k y(n-k) + sum_(k=0)^M b_k x(n-k)
$

缺点：
- 系数对滤波器的性能控制作用不直接
- 极点对系数的量化效应过于灵敏，易出现不稳定或较大误差
- 运算的累积误差较大
- 存储器消耗较大

#align(center + horizon)[#image("iir-form1.png", width: 45%)]
#align(center + horizon)[#image("iir-form2.png", width: 35%)]

=== 级联型

对系统函数进行因式分解，两两配对，

$
  H(z)&=A product_k
  (1 + beta_(1 k)z^(-1) + beta_(2 k)z^(-2)) / (1 - alpha_(1 k)z^(-1) - alpha_(2 k)z^(-2))
  &=A product_k H_k(z)
$

特点：
- 单独调整每个级联子系统的参数
- 累计误差小
- 存储器消耗少

#align(center + horizon)[#image("iir-cas.png", width: 30%)]

=== 并联型

对系统函数进行部分分式展开，然后进行并联。

$
  H(z)&=G_0 + A sum_k
  (gamma_(0 k) + gamma_(1 k)z^(-1)) / (1 - alpha_(1 k)z^(-1) - alpha_(2 k)z^(-2))
  &=A sum_k H_k(z)
$

特点：
- 可以通过调整参数调整一对极点位置，但不能单独调整零点位置
- 误差最小
- 并行运算，速度最高

#align(center + horizon)[#image("iir-prl.png", width: 30%)]


== FIR

- 横截型

$
  y(n)=sum_(k=0)^(M-1) b_k x(n-k)
$

#align(center + horizon)[#image("fir-v.png", width: 60%)]

- 级联型

$
  H(z)=A product_(k=1) (beta_(0 k) + beta_(1 k)z^(-1) + beta_(2 k)z^(-2))
$

#align(center + horizon)[#image("fir-h.png", width: 60%)]


级联型的每节控制一对零点，但系数更多，需要更多的乘法运算。

=== 线性相位结构

FIR滤波器若参数对称，则其相位是线性的。

#align(center + horizon)[#image("lphase.png", width: 60%)]

偶对称取正反馈，奇对称取负反馈。

如果长度为偶数，那么删去最右侧的直接路径，并削减一个延迟。

== 滤波器设计

因果稳定的LSI系统不能实现理想滤波器，只能逼近。

概念：通阻、过渡带、截止频率、容限。

群时延：$tau_g = -(dif phi) / (dif omega)$，即相移响应对频率的负导数。若位常数则代表线性相位。

线性系统的群延时是常数，$tau = (N-1)/2$，其中$N$是滤波器的长度。

全通系统：幅度响应全为1。应用：
- 任一LS系统都可表示为全通和最小相位系统的级联。
- 级联全通系统使非稳定滤波器变成稳定滤波器。
- 作相位均衡器

=== IIR的设计方法

1. 冲击响应不变法
特点：
- 完全模拟模拟滤波器的单位抽样响应，时域逼近良好
- 线性相位
- 频率响应混叠，只能用于低通、带通滤波器

2. 双线性变换法
特点：
- 避免频率响应混叠
- 除零频率附近，模拟和数字频率之间非线性，需要预畸变

=== FIR的设计方法

窗函数选择要求：
- 减少窗谱主瓣的宽度，以获得较陡的过渡带
- 减少窗谱最大旁瓣的相对幅度，以减小肩峰和波纹

窗函数的性质：
- 主瓣与旁瓣的比例由窗函数形状决定
- 阻带最小衰减由窗函数形状决定
- 过渡带宽由窗函数形状和阶数决定
- 滤波器阶数影响窗谱主瓣的宽度

常见窗函数：
- 矩形窗、三角形窗（Bartlett窗）
- 汉明窗（升余弦窗）、汉宁窗（改进升余弦窗）、布莱克曼窗（二阶升余弦窗）
- 凯泽窗（可变参数）
