select *
from PortfolioProject..NashvilleHousing

select SaleDate, convert (date, SaleDate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SaleDate= convert(date, SaleDate)

alter table NashvilleHousing
Add SaleDataConverted Date;

update NashvilleHousing
set SaleDataConverted= convert(date, SaleDate)

select SaleDataConverted, convert(Date, SaleDate)
from PortfolioProject..NashvilleHousing

select *
from PortfolioProject..NashvilleHousing
where PropertyAddress is null


Select a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
set propertyaddress= isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address into individual columns
select *
from PortfolioProject..NashvilleHousing
where PropertyAddress is null


select
substring (propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
from PortfolioProject..NashvilleHousing

select
substring (propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address1,
substring (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address2
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
add propertySplitAddress Nvarchar(255);


ALTER TABLE NashvilleHousing
ALTER COLUMN propertySplitAddress  Nvarchar(255);

EXEC sp_rename 'NashvilleHousing.SaleDataConverted', 'SaleDateConverted', 'COLUMN';

update NashvilleHousing
set propertySplitAddress=substring (propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


select top 80 *
from NashvilleHousing

alter table NashvilleHousing
add propertySplitCity varchar(255)

update NashvilleHousing
set propertysplitcity= substring (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


select
PARSENAME (replace(Owneraddress,',', '.'),3), 
PARSENAME (replace(Owneraddress, ',','.'),2),
PARSENAME (replace(Owneraddress, ',','.'),1)
from NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress= PARSENAME (replace(Owneraddress,',', '.'),3)

select top 60 *
from NashvilleHousing


alter table NashvilleHousing
add OwnerSplitCity varchar(255)

update NashvilleHousing
set OwnerSplitCity= PARSENAME (replace(Owneraddress, ',','.'),2)


alter table NashvilleHousing
add OwnerSplitState varchar(255)


update NashvilleHousing
set OwnerSplitState= PARSENAME (replace(Owneraddress, ',','.'),1)


--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (SoldasVacant), count(soldasvacant)
from NashvilleHousing
group by soldasvacant
order by 2


select soldasvacant,
case when soldasvacant='Y' then 'Yes'
	 when soldasvacant='N' then 'No'
	 else soldasvacant
	 end
from NashvilleHousing

update NashvilleHousing
set soldasvacant= case when soldasvacant='Y' then 'Yes'
	 when soldasvacant='N' then 'No'
	 else soldasvacant
	 end
	 from NashvilleHousing

--Remove Duplicates
with rownumCTE as(
select *, 
	row_number() OVER(
	partition by parcelID, 
	PropertyAddress,
	SalePrice, 
	SaleDate,
	LegalReference
	ORDER BY UniqueID) row_num
from NashvilleHousing)
Select *
from rownumCTE
where row_num>1
--order by propertyaddress


--Delete Unused Columns
select *
from NashvilleHousing

alter table NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress

alter table NashvilleHousing
drop column saledate