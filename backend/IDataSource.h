#ifndef IDATASOURCE_H
#define IDATASOURCE_H

class IDataSource
{
public:
    virtual ~IDataSource() = default;

    virtual void start() = 0;
};

#endif // IDATASOURCE_H