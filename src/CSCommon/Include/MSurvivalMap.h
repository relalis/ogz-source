#ifndef _MSURVIVAL_MAP_H
#define _MSURVIVAL_MAP_H

// 서바이벌 맵 종류
enum MSURVIVAL_MAP
{
	MSURVIVAL_MAP_HALL2 = 0,
	MSURVIVAL_MAP_ROOM3,

	MSURVIVAL_MAP_END
};

// 서바이벌 맵 정보
struct MSurvivalMapInfo
{
	MSURVIVAL_MAP		nID;
	char				szName[64];
};


class MSurvivalMapCatalogue
{
private:
	// 멤버 변수
	MSurvivalMapInfo		m_MapInfo[MSURVIVAL_MAP_END];

	// 함수
	void SetMap(MSURVIVAL_MAP nMap, const char* szMapName);
	void Clear();
public:
	MSurvivalMapCatalogue();
	~MSurvivalMapCatalogue();
	MSurvivalMapInfo* GetInfo(MSURVIVAL_MAP nMap);
};



#endif