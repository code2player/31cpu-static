
#include <stdio.h>

int main()
{
	int bottom_floor=1;//�ײ� 
	int top_floor=11;//���� 
	int enough_value=8;//��ˤֵ 	
	int times=0;//���� 
	
	
	while(1) 
	{
		if(bottom_floor+1>=top_floor)
		break;
		
		times+=1;
		int mid=(bottom_floor+top_floor)/2;
		if(mid<=enough_value)
		bottom_floor=mid;
		else
		top_floor=mid;		
	}
	printf("times:%d\n",times);
	printf("enough_value:%d\n",bottom_floor);

	return 0;
}
