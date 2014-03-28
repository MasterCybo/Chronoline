<?php

namespace FourmilabCalendarConverter
{

class Calendar
{
	const GREGORIAN_EPOCH=1721425.5;
	const HEBREW_EPOCH=347995.5;
	const ISLAMIC_EPOCH=1948439.5;
	const PERSIAN_EPOCH=1948320.5;
	const TropicalYear=365.24219878;
	const J1970=2440587.5;
	static function isLeap($year,$calendar)
	{
		switch($calendar)                    
		{
			case 'indian':
			case 'gregorian':
				return (($year % 4) == 0) && (!(($year % 100)==0 && ($year % 400) != 0));
			case 'julian':
				return self::mod($year,4)==(($year>0)?0:3);
			case 'hebrew':
				return self::mod($year*7+1,19)<7;
	
		}		
	}
	static private function hebrew_year_months($year)
	{
		return self::isLeap($year,'hebrew')?13:12;
	}
	//  Test for delay of start of new year and to avoid Sunday, Wednesday, and Friday as start of the new year.
	static private function hebrew_delay_1($year)
	{
		$months=floor((235*$year-234)/19);
		$parts=12084+13753*$months;
		$day=($months*29)+floor($parts/25920);
		if (self::mod(3*($day+1),7)<3) 
			++$day;
		return $day;
	}
	//  Check for delay in start of new year due to length of adjacent years
	static private function hebrew_delay_2($year)
	{
		$last=self::hebrew_delay_1($year-1);
		$present=self::hebrew_delay_1($year);
		$next=self::hebrew_delay_1($year+1);
		return ($next-$present==356)?2:(($present-$last==382)?1:0);
	}
	//  How many days are in a given month of a given year
	static private function hebrew_month_days($year,$month)
	{
		//  First of all, dispose of fixed-length 29 day months
		if ($month==2 || $month==4 || $month==6 || $month==10 || $month==13)
			return 29;

		//  If it's not a leap year, Adar has 29 days
		if ($month==12 && !self::isLeap($year,'hebrew')) 
			return 29;

		//  If it's Heshvan, days depend on length of year
		if ($month==8 && !(self::mod(self::hebrew_year_days($year),10)==5)) 
			return 29;

		//  Similarly, Kislev varies with the length of year
		if ($month==9 && (self::mod(self::hebrew_year_days($year),10)==3)) 
			return 29;

		//  Nope, it's a 30 day month
		return 30;
	}
	static private function hebrew_year_days($year)
	{
		return self::converttoJD(1,7,$year+1,0,0,'hebrew')-self::converttoJD(1,7,$year,0,0,'hebrew');
	}
	static function converttoJD($day,$month,$year,$hour,$minute,$from)
	{
		$jd=0;
		switch($from)
		{
			case 'gregorian':
				$jd=(self::GREGORIAN_EPOCH-1)+
					(365*($year - 1))+
					floor(($year-1)/4)-
					floor(($year-1)/100)+
					floor(($year-1)/400)+
					floor((((367*$month)-362)/12)+(($month<=2)?0:(self::isLeap($year,$from)?-1:-2))+$day);
				break;
			case 'julian':
/* Adjust negative common era years to the zero-based notation we use.  */
				if ($year < 1) 
					++$year;

/* Algorithm as given in Meeus, Astronomical Algorithms, Chapter 7, page 61 */
				if ($month<=2) 
				{
					--$year;
					$month+=12;
				}
				$jd=(floor(365.25*($year+4716))+floor(30.6001*($month+1))+$day)-1524.5;
				break;
			case 'hebrew':
				$months=self::hebrew_year_months($year);
				$jd=self::HEBREW_EPOCH+self::hebrew_delay_1($year)+self::hebrew_delay_2($year)+$day+1;
				if ($month<7) 
				{
					for ($mon=7;$mon<=$months;++$mon) 
						$jd+=self::hebrew_month_days($year,$mon);
					for ($mon=1;$mon<$month;++$mon) 
						$jd+=self::hebrew_month_days($year,$mon);
				} 
				else 
					for ($mon=7;$mon<$month;++$mon) 
						$jd+=self::hebrew_month_days($year,$mon);
				break;
			case 'islamic':
				$jd=$day+ceil(29.5*($month-1))+($year-1)*354+floor((3+11*$year)/30)+self::ISLAMIC_EPOCH-1;
				break;
			case 'indian':
				$gyear=$year+78;
				$leap=self::isLeap($gyear,'indian');     // Is this a leap year ?
				$start=self::converttoJD($leap?21:22,3,$gyear,0,0,'gregorian');
				$Caitra=$leap?31:30;

				if ($month==1) 
				{
					$jd=$start+($day-1);
				} 
				else 
				{
					$jd=$start+$Caitra;
					$m=min($month-2,5);
					$jd+=$m*31;
					if ($month>=8) 
					{
						$m=$month-7;
						$jd+=$m*30;
					}
					$jd+=(day-1);
				}
				break;
			case 'unixtime':
					$jd=self::J1970+mktime(0,0,0,$month,$day,$year)/86400;
				break;
		}
		$jd+=(($hour*60+$minute)/1440);
		return $jd;
	}
	static function convertfromJD($jd,$to)
	{
		$return=array();
		$tmpjd=$jd+0.5;
		$tmpjd=(($tmpjd-floor($tmpjd))*86400.0)+0.5;
		$hour=floor($tmpjd/3600);
		$minute=floor(($tmpjd/60)%60);
		$jd-=($hour/24+$minute/1440);
		
		switch($to)
		{
			case 'gregorian':
				$wjd=floor($jd-0.5)+0.5;
				$depoch=$wjd-self::GREGORIAN_EPOCH;
				$quadricent=floor($depoch/146097);
				$dqc=self::mod($depoch,146097);
				$cent=floor($dqc/36524);
				$dcent=self::mod($dqc,36524);
				$quad=floor($dcent/1461);
				$dquad=self::mod($dcent,1461);
				$yindex=floor($dquad/365);
				$year=($quadricent*400)+($cent*100)+($quad*4)+$yindex;
				if ($cent!=4 && $yindex!= 4) 
					++$year;
				$yearday=$wjd-self::converttoJD(1,1,$year,0,0,"gregorian");
				$leapadj=(($wjd<self::converttoJD(1,3,$year,0,0,"gregorian"))?0:(self::isLeap($year,"gregorian")?1:2));
				$month=floor(((($yearday+$leapadj)*12)+373)/367);
				$day=($wjd-self::converttoJD(1,$month,$year,0,0,"gregorian"))+1;
				/*$s=$jd+0.5;
				$s=(($s-floor($s))*86400.0)+0.5;
				$hour=floor($s/3600);
				$minute=floor(($s/60)%60);*/
				return array("day"=>$day,"month"=>$month,"year"=>$year,"hour"=>$hour,"minute"=>$minute);
			case 'julian':
				$jd+=0.5;
				$z=floor($jd);
				$a=$z;
				$b=$a+1524;
				$c=floor(($b-122.1)/365.25);
				$d=floor(365.25*$c);
				$e=floor(($b-$d)/30.6001);
				$month=floor(($e<14)?($e-1):($e-13));
				$year=floor(($month>2)?($c-4716):($c-4715));
				$day=$b-$d-floor(30.6001*$e);
/*  If year is less than 1, subtract one to convert from a zero based date system to the common era system in which the year -1 (1 B.C.E) is followed by year 1 (1 C.E.).  */
				if ($year<1)
					--$year;
				$s=$jd;
				/*$s=(($s-floor($s))*86400.0)+0.5;
				$hour=floor($s/3600);
				$minute=floor(($s/60)%60);*/
				return array("day"=>$day,"month"=>$month,"year"=>$year,"hour"=>$hour,"minute"=>$minute);
			case 'hebrew':
				$sjd=$jd;
				$jd=floor($jd)+0.5;
				$count=floor((($jd-self::HEBREW_EPOCH)*98496.0)/35975351.0);
				$year=$count-1;
				for ($i=$count;$jd>=self::converttoJD(1,7,$i,0,0,'hebrew');++$i) 
					++$year;
				$first=($jd<self::converttoJD(1,1,$year,0,0,'hebrew'))?7:1;
				$month=$first;
				for ($i=$first;$jd>self::converttoJD(self::hebrew_month_days($year,$i),$i,$year,0,0,'hebrew'); ++$i) 
					++$month;
				$day=($jd-self::converttoJD(1,$month,$year,0,0,'hebrew')) + 1;
				/*$s=$sjd+0.5;
				$s=(($s-floor($s))*86400.0)+0.5;
				$hour=floor($s/3600);
				$minute=floor(($s/60)%60);*/
				return array("day"=>$day,"month"=>$month,"year"=>$year,"hour"=>$hour,"minute"=>$minute);
			case 'islamic':
				$jd=floor($jd)+0.5;
				$year=floor((30*($jd-self::ISLAMIC_EPOCH)+10646)/10631);
				$month=min(12,ceil(($jd-(29+self::converttoJD(1,1,$year,0,0,'islamic')))/29.5)+1);
				$day=($jd-self::converttoJD(1,$month,$year,0,0,'islamic'))+1;
				$s=$jd;
				/*$s=(($s-floor($s))*86400.0)+0.5;
				$hour=floor($s/3600);
				$minute=floor(($s/60)%60);*/
				return array("day"=>$day,"month"=>$month,"year"=>$year,"hour"=>$hour,"minute"=>$minute);
			case 'indian':
				$Saka=78;                    // Offset in years from Saka era to Gregorian epoch
				$start = 80;                       // Day offset between Saka and Gregorian

				$jd=floor($jd)+0.5;
				$greg=self::convertfromJD($jd,'gregorian');       // Gregorian date for Julian day
				$leap=self::isLeap($greg['year'],'indian');   // Is this a leap year?
				$year=$greg['year']-$Saka;            // Tentative year in Saka era
				$greg0=self::converttoJD(1,1,$greg['year'],0,0,'gregorian'); // JD at start of Gregorian year
				$yday=$jd-$greg0;                // Day number (0 based) in Gregorian year
				$Caitra=$leap?31:30;          // Days in Caitra this year

				if ($yday<$start) 
				{
					//  Day is at the end of the preceding Saka year
					--$year;
					$yday+=($Caitra+(31*5)+(30*3)+10+$start);
				}

				$yday-=$start;
				if ($yday<$Caitra) 
				{
					$month=1;
					$day=$yday+1;
				} 
				else 
				{
					$mday=$yday-$Caitra;
					if ($mday<(31*5)) 
					{
						$month=floor($mday/31)+2;
						$day=($mday%31)+1;
					} 
					else 
					{
						$mday-=31*5;
						$month=floor($mday/30)+7;
						$day=($mday%30)+1;
					}
				}
				return array("day"=>$day,"month"=>$month,"year"=>$year,"hour"=>$hour,"minute"=>$minute);
			case 'unixtime':
				$unixtime=$jd-self::J1970;
				return array("day"=>date('j',$unixtime),"month"=>date('n',$unixtime),"year"=>date('Y',$unixtime),"hour"=>date('G',$unixtime),"minute"=>date('i',$unixtime));
		}
	}
	static private function mod($a,$b)
	{
		return $a-($b*floor($a/$b));
	}
}

} //End namespace

$calendars=array("gregorian","julian","hebrew","islamic",'indian');
foreach($calendars as $v)
{
	$arr=FourmilabCalendarConverter\Calendar::convertfromJD(Calendar::converttoJD(1,1,2000,15,20,$v),$v);
	echo $v.' : '.$arr['day'].'/'.$arr['month'].'/'.$arr['year'].'   '.$arr['hour'].':'.$arr['minute']."\n";
}


?>