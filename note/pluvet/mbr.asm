section mbr vstart=0x7c00   ; 把起始位置编译为 0x7c00
    ; 此时 cs 为 0，利用 cs 的值去初始化其它寄存器
    mov ax, cs   ;CS是代码段寄存器, ax 是累加寄存器。移动 cs 的值到 ax。
    mov ds, ax   ;DS 是数据段寄存器
    mov es, ax   ;ES（Extra Segment）：附加段寄存器。
    mov ss, ax   ;SS:存放栈的段地址；
    mov fs, ax   ;FS寄存器指向当前活动线程的TEB结构（线程结构）
    mov sp, 0x7c00   ;sp是栈顶指针，它每次指向栈顶。这里初始化栈指针，
                     ; 这样在之后就可以用 0x7c00 之后的区域作为栈使用。
    ; 利用 int 0x10 上卷全部行实现清屏
    mov ax, 0x600
    mov bx, 0x700
    mov cx, 0       ;左上角 (0,0)
    mov dx, 0x184f  ;右下角 (80,25)
    
    int 0x10;
    ; 获取光标位置
    mov ah, 3   ; 把 3 存入 ah，表示调用 3 号子功能获取光标位置
    mov bh, 0   ; bh 存待获取光标的页号
    
    int 0x10    ; 输出 ch = 光标开始行，cl = 光标结束行
                ; dh = 光标所在行号，dl = 光标所在列号
    ; 打印字符串
    
    mov ax, message
    mov bp, ax
                ; es:bp 字符串的首地址，es 此时和 cs 一致
                ; 开头时已经为 sreg 初始化
    mov cx, 5
    mov ax, 0x1301  ; ah 为 13，表示调用子功能 13：显示字符
                    ; al 为 01，表示设置写字符的方式为显示字符串，
                    ;光标跟随移动。
    mov bx, 0x2     ; bh 为 0， 表示显示的页号为 0
                    ; bl 为字符属性，这里 bl = 02h 表示黑底绿字
    ; 打印字符串结束
    int 0x10  

    jmp $           ; 使程序悬停在此
    
    message db "1 MBR"
    times 510-($-$$) db 0   ; 用 0 填充剩余的字节
                            ; 这里 $ 是本行的偏移量，
                            ; $$ 是本 section 的起始位置。
                            ; 下面的 0x55 和 0xaa 占两个字节，
                            ; 除了这两个还剩下 510 个字节。
                            ; 减去代码占用的字节，
                            ; 就是实际剩余的字节
    db 0x55, 0xaa
                    
    
                