-- Cleaning data in SQL Queries








-- Standardize Date Format

   

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE Housing.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select NashvilleHousing.SaleDateConverted, CONVERT(Date, SaleDate)
From NashvilleHousing  

--Populate Property Address data


select *
From NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Housing.dbo.NashvilleHousing a
JOIN Housing.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Housing.dbo.NashvilleHousing a
JOIN Housing.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is NULL

-- Breaking out  Property Address into Individual Columns 9Address, City, State)

select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress)) AS Address
From Housing.dbo.NashvilleHousing

ALTER TABLE Housing.dbo.NashvilleHousing
Add PropertySplitAddress NVARCHAR(225);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Housing.dbo.NashvilleHousing
Add PropertySplitCity NVARCHAR(225);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress))

Select *
FROM Housing.dbo.NashvilleHousing

-- We are using comma above as delimeter to seperate the address in different parts

-- Change y and n into yes and no

SELECT distinct(soldasvacant), count(soldasvacant)
from Housing.dbo.NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant

select soldasvacant
 , CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN Soldasvacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM Housing.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN Soldasvacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END

-- Remove Duplicates we assume there are no primary key in this datasets to identify duolicates, but there are in this dataset like iniqueid and LegalReference still we will follow normal steps and query it to find duplicates


WITH RowNumCTE AS(
select *,
  ROW_NUMBER() OVER(
  PARTITION BY ParcelID,
               SalePrice,
			   SaleDate,
			   LegalReference
			   Order by 
			     UniqueID
				 ) row_num
FROM Housing.dbo.NashvilleHousing
--order by ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_num > 1

-- Delete Unused Columns




ALTER TABLE Housing.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE Housing.dbo.NashvilleHousing
DROP COLUMN SaleDate

-- our data is cleaned and standardized now