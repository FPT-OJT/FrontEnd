const mockMerchantCategoriesJson = '''
{
  "statusCode": 200,
  "message": "Success",
  "data": [
    {
      "id": "019c02b0-c9aa-75f9-8af0-3dad03f9aa6e",
      "categoryName": "Dining & Food",
      "imageUrl": "https://res.cloudinary.com/dkvga054t/image/upload/v1769569424/enjoying-a-brunch-together_kanm19.jpg",
      "createdAt": "2026-01-29T00:00:00Z",
      "updatedAt": "2026-01-29T00:00:00Z"
    },
    {
      "id": "019c02b1-00e5-7303-bcb1-8e27d6077ea7",
      "categoryName": "Shopping & Retail",
      "imageUrl": "https://res.cloudinary.com/dkvga054t/image/upload/v1769569494/images_ygthjk.jpg",
      "createdAt": "2026-01-29T00:00:00Z",
      "updatedAt": "2026-01-29T00:00:00Z"
    },
    {
      "id": "019c02b1-00e5-7a51-8fb8-255169573de1",
      "categoryName": "Groceries & Supermarkets",
      "imageUrl": "https://res.cloudinary.com/dkvga054t/image/upload/v1769569608/food-prices-vary-widely-among-grocery-stores-1704834105_kwuxmg.jpg",
      "createdAt": "2026-01-29T00:00:00Z",
      "updatedAt": "2026-01-29T00:00:00Z"
    },
    {
      "id": "019c02b1-00e5-7159-90fd-32645d44a8e9",
      "categoryName": "Entertainment",
      "imageUrl": "https://res.cloudinary.com/dkvga054t/image/upload/v1769569673/18-26-1_hayxkj.jpg",
      "createdAt": "2026-01-29T00:00:00Z",
      "updatedAt": "2026-01-29T00:00:00Z"
    },
    {
      "id": "019c02b1-00e5-7996-a7fc-3cd18f88f945",
      "categoryName": "Health & Beauty",
      "imageUrl": "https://res.cloudinary.com/dkvga054t/image/upload/v1769569721/images_s1ayc7.jpg",
      "createdAt": "2026-01-29T00:00:00Z",
      "updatedAt": "2026-01-29T00:00:00Z"
    }
  ]
}
''';

const mockMerchantAgencies = '''
[
  {
    "id": "019c02b1-00e5-771c-ab2a-a29038f14e43",
    "name": "Starbucks New World",
    "longitude": 106.694419,
    "latitude": 10.771918,
    "imageUrl": null,
    "merchant": {
      "id": "019c02b1-00e5-76a2-b661-47c415151720",
      "name": "Starbucks Vietnam",
      "mcc": "5814",
      "logoUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRowblgC4PDfdIlo9vW2F3Sf1n_VaOFhMIeXA&s"
    }
  },
  {
    "id": "019c02b1-00e5-71df-b21c-15fd36d72cb0",
    "name": "Starbucks Rex Hotel",
    "longitude": 106.701944,
    "latitude": 10.776111,
    "imageUrl": null,
    "merchant": {
      "id": "019c02b1-00e5-76a2-b661-47c415151720",
      "name": "Starbucks Vietnam",
      "mcc": "5814",
      "logoUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRowblgC4PDfdIlo9vW2F3Sf1n_VaOFhMIeXA&s"
    }
  },
  {
    "id": "019c02b5-e5cd-76a1-a5bd-3aa7b05d6cdd",
    "name": "Starbucks Landmark 81",
    "longitude": 106.721944,
    "latitude": 10.795111,
    "imageUrl": null,
    "merchant": {
      "id": "019c02b1-00e5-76a2-b661-47c415151720",
      "name": "Starbucks Vietnam",
      "mcc": "5814",
      "logoUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRowblgC4PDfdIlo9vW2F3Sf1n_VaOFhMIeXA&s"
    }
  },
  {
    "id": "019c02b5-e5cd-7f99-af6e-a7be68d12e09",
    "name": "Haidilao Vincom Center",
    "longitude": 106.702222,
    "latitude": 10.778056,
    "imageUrl": null,
    "merchant": {
      "id": "019c02b1-00e5-7610-ae32-194cd6ad2ac0",
      "name": "Haidilao Hotpot",
      "mcc": "5812",
      "logoUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT89MVUx-5iG-UZGDMtvPB78CINDzOMJ4yvlg&s"
    }
  },
  {
    "id": "019c02b5-e5cd-7ed5-817e-ece3461c225a",
    "name": "Haidilao Bitexco",
    "longitude": 106.7045,
    "latitude": 10.7715,
    "imageUrl": null,
    "merchant": {
      "id": "019c02b1-00e5-7610-ae32-194cd6ad2ac0",
      "name": "Haidilao Hotpot",
      "mcc": "5812",
      "logoUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT89MVUx-5iG-UZGDMtvPB78CINDzOMJ4yvlg&s"
    }
  },
  {
    "id": "019c02b5-e5cd-7270-963a-cfd6461c4c3d",
    "name": "Uniqlo Dong Khoi",
    "longitude": 106.7025,
    "latitude": 10.778333,
    "imageUrl": null,
    "merchant": {
      "id": "019c02b1-00e5-7ae5-a057-4424bf3e1413",
      "name": "Uniqlo",
      "mcc": "5651",
      "logoUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbUwyXs85fpEi-MxJE3k2lImkoDo25suHx0A&s"
    }
  },
  {
    "id": "019c02b5-e5cd-7e3c-8e8d-fe7a6ca2177e",
    "name": "Uniqlo Saigon Centre",
    "longitude": 106.703611,
    "latitude": 10.773889,
    "imageUrl": null,
    "merchant": {
      "id": "019c02b1-00e5-7ae5-a057-4424bf3e1413",
      "name": "Uniqlo",
      "mcc": "5651",
      "logoUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbUwyXs85fpEi-MxJE3k2lImkoDo25suHx0A&s"
    }
  },
  {
    "id": "019c02b5-e5cd-70bc-bc1b-fe63e5096866",
    "name": "Zara Vincom Center",
    "longitude": 106.7022,
    "latitude": 10.778,
    "imageUrl": null,
    "merchant": {
      "id": "019c02b1-00e5-7543-8a2d-0fe0b5d73c7d",
      "name": "Zara",
      "mcc": "5691",
      "logoUrl": "https://crystalpng.com/wp-content/uploads/2025/12/Zara-Logo.png"
    }
  }
]

''';
