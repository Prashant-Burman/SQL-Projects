-- Cleaning Data in SQL 
	
---------------------------------------------------------------------------------------------------------

-- Standardize Date Format


select * from nashvillehousing

Select saledate, CONVERT(date,SaleDate) sale_date  from nashvillehousing

Alter table nashvillehousing
add Sale_date date

update nashvillehousing
set Sale_date = CONVERT(date,SaleDate)



----------------------------------------------------------------------------------------------------------

-- Populate Property Address Data



Select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress) 
from nashvillehousing a
join nashvillehousing b
on a.ParcelID = b.ParcelID and
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
from nashvillehousing a
join nashvillehousing b
on a.ParcelID = b.ParcelID and
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



select * from nashvillehousing where PropertyAddress is null




----------------------------------------------------------------------------------------------------------

-- Breaking out Address into individual columns (Address,City,State)


Select propertyaddress, SUBSTRING(propertyaddress,1,CHARINDEX(',',Propertyaddress)-1) propertysplitaddress,

SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress)) propertysplitcity
from  nashvillehousing

Alter table nashvillehousing
Add propertysplitaddress nvarchar(255),propertysplitcity nvarchar(255)

update nashvillehousing
set propertysplitaddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',Propertyaddress)-1),
propertysplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))


select owneraddress, 
PARSENAME(replace(owneraddress,',','.'),3) ownersplitaddress,
PARSENAME(replace(owneraddress,',','.'),2) ownersplitcity,
PARSENAME(replace(owneraddress,',','.'),1) ownersplitstate
from
nashvillehousing

Alter table nashvillehousing
add ownersplitaddress nvarchar(255),ownersplitcity nvarchar(255),ownersplitstate nvarchar(255)

update nashvillehousing
set ownersplitaddress = PARSENAME(replace(owneraddress,',','.'),3), 
ownersplitcity = PARSENAME(replace(owneraddress,',','.'),2),
ownersplitstate = PARSENAME(replace(owneraddress,',','.'),1)  

select * from nashvillehousing


----------------------------------------------------------------------------------------------------------

-- Change  Y and N to Yes and No in  " Sold as Vacacnt" field


select * from nashvillehousing

select distinct soldasvacant from nashvillehousing


select soldasvacant, case when soldasvacant = 'Y' then 'Yes' 
					      when soldasvacant = 'N' then 'No'
						  else soldasvacant
						  end as sold_as_vacant
from nashvillehousing




----------------------------------------------------------------------------------------------------------

-- Remove Duplicates



With rownumcte as
(
select *, ROW_NUMBER()
over(
Partition by parcelid,propertyaddress,saledate,saleprice,legalreference order by uniqueID) row_num,
Rank()
over(
Partition by parcelid,propertyaddress,saledate,saleprice,legalreference order by uniqueID) rnk,
dense_Rank()
over(
Partition by parcelid,propertyaddress,saledate,saleprice,legalreference order by uniqueID) densernk

from nashvillehousing
)


select * from rownumcte --where row_num > 1
order by row_num desc, rnk desc




----------------------------------------------------------------------------------------------------------

-- Delete Unused columns


Alter table nashvillehousing
drop propertyaddress,saledate, owneraddress,taxdistrict







