/* Cleaning Data in SQL Query*/

SELECT *
	FROM PortfolioProject.dbo.NashvilleHousing

		 -- Standarized Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
	FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
	SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
	ADD SaleDateConverted Date;

UPDATE NashvilleHousing
	SET SaleDateConverted = CONVERT(Date, SaleDate)


		-- Populate Property Address Data

SELECT *
	FROM PortfolioProject.dbo.NashvilleHousing
		--WHERE PropertyAddress IS NULL
	ORDER BY ParcelID

SELECT 
	a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
	FROM PortfolioProject.dbo.NashvilleHousing a
	JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL

UPDATE a
	SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
	FROM PortfolioProject.dbo.NashvilleHousing a
	JOIN PortfolioProject.dbo.NashvilleHousing b
		ON a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL


/* Breaking Out Address into Individaul Columns (Address, City, State) */
SELECT PropertyAddress
	FROM PortfolioProject.dbo.NashvilleHousing
	--WHERE PropertyAddress IS NULL
	--ORDER BY ParcelID

SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM 
	PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
	ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
	SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
	ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
	SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
	FROM PortfolioProject.dbo.NashvilleHousing

SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM
	PortfolioProject.dbo.NashvilleHousing
		-- Address:
ALTER TABLE NashvilleHousing
	ADD	OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
	SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

		-- City:
ALTER TABLE NashvilleHousing
	ADD	OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
	SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

		-- State:
ALTER TABLE NashvilleHousing
	ADD	OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
	SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
	FROM 
		PortfolioProject.dbo.NashvilleHousing


/* Change Y and N to YES and NO in "Sold as Vacant" field*/
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
	FROM
		PortfolioProject.dbo.NashvilleHousing
	GROUP BY
			SoldAsVacant
	ORDER BY
			2

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
	SET SoldAsVacant = CASE WHEN SoldAsVacant = 'y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


			/* Remove Duplicates */
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER()
	OVER
	(
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
						UniqueID)
					row_num
FROM PortfolioProject.dbo.NashvilleHousing
)
--ORDER BY ParcelID
SELECT * FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

SELECT * FROM PortfolioProject.dbo.NashvilleHousing


		 /* Delete Unused Columns */
SELECT * FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress , TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate