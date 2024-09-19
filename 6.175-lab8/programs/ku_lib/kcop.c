int kgetTime()
{
  int ret;
  asm volatile ( "mfc0 %0, $10" : "=r" (ret) :);
  return ret;
}

int kgetInsts()
{
  int ret;
  asm volatile( "mfc0 %0, $11" : "=r" (ret) :);
  return ret;
}
