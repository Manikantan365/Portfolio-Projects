Select *
From PortfolioProject.dbo.Sheet

-- Standardize Date Format

Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.Sheet

------------------------------------------------------
-- Populate Property Address data

Select *
From PortfolioProject.dbo.Sheet
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.Sheet a
JOIN PortfolioProject.dbo.Sheet b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.Sheet a
JOIN PortfolioProject.dbo.Sheet b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

----------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.Sheet

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.Sheet

ALTER TABLE Sheet
Add PropertySplitAddress Nvarchar(255);

Update Sheet
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Sheet
Add PropertySplitCity Nvarchar(255);

Select *
From PortfolioProject.dbo.Sheet




Update Sheet
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


----------------------------------------------------------------------------------------------------------

-- Breaking out OwnerAddress into Individual Columns (OwnerSplitAddress, OwnerSplitCity, OwnerSplitState)
Select OwnerAddress
From PortfolioProject.dbo.Sheet


Select 
PARSENAME (REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.Sheet

ALTER TABLE Sheet
Add OwnerSplitAddress Nvarchar(255);
Update Sheet
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Sheet
Add OwnerSplitCity Nvarchar(255);
Update Sheet
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE Sheet
Add OwnerSplitState Nvarchar(255);
Update Sheet
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (SoldAsVacant),Count(SoldAsVacant)
From  PortfolioProject.dbo.Sheet
Group By SoldAsVacant
order By 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.Sheet

Update Sheet
SET SoldAsVacant = 
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- Delete Unused Columns
Select *
From PortfolioProject.dbo.Sheet


ALTER TABLE PortfolioProject.dbo.Sheet
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE PortfolioProject.dbo.Sheet
DROP COLUMN SaleConvertedDate