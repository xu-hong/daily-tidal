osc(20, 0.1, ()=>0.168*(1+Math.sin(time*1.10)))
.modulate(osc(2, 1.1).rotate())
  .modulateScale(o1)
  .add(
    shape(30,0.4,0.1).diff(gradient(10.1)))
  .saturate(10.1)
  // .blend(o0)
  // .blend(o0)
  // .blend(o0)
  // .blend(o0)
  .out(o0);

noise(3, 0.763)
  .add(gradient(1.1))
  .luma(0.1, 0.067)
  .modulateScale(o1)
  .mask(
    shape(30, 0.1, 0.7)
     .color(1,1,0)
   )
  .out(o0);

src(o0).diff(osc().rotate(0,0.1)).out(o1);

render(o0);
